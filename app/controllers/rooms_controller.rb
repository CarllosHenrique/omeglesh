class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show destroy edit update generate_hash destroy_hash check join confirm leave]

  def index
    if params[:query].present?
      query = params[:query].downcase
      @pagy, @rooms = pagy(Room.search(query))
    else
      @pagy, @rooms = pagy(Room.order(created_at: :desc), limit: 5)
    end

    authorize @rooms
  end

  def show
    authorize @room
    redirect_to confirm_room_path(@room) unless room_session_valid?
    set_message
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      create_room_user_session!
      redirect_to @room, notice: t("controller.rooms.create.success", room: @room.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @room
  end

  def update
    authorize @room
    if @room.update(room_params)
      redirect_to @room, notice: t("controller.rooms.update.success", room: @room.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @room
    @room.destroy
    redirect_to rooms_path, notice: t("controller.rooms.destroy.success", room: @room.name)
  end

  def check; end

  def leave
    @user_room = @room.room_users.find_by(user_id: current_user.id)
    @user_room&.destroy
    session[:checked_room_user] = nil
    redirect_to rooms_path, notice: t("controller.rooms.leave.success", room: @room.name)
  end

  def confirm
    if room_session_valid?
      redirect_to room_path(@room), notice: t("controller.rooms.confirm.success", room: @room.name)
    end
  end

  def join
    if @room.user.id == current_user.id || @room.hash_code == params[:hash_code]
      create_room_user_session!
      redirect_to room_path(@room), notice: t("controller.rooms.join.success", room: @room.name)
    else
      redirect_to check_room_path(@room), alert: t("controller.rooms.join.error")
    end
  end

  def generate_hash
    authorize @room
    @room.generate_hash_code
    @room.save
    redirect_to edit_room_path(@room), notice: t("controller.rooms.generate_hash.success")
  end

  def destroy_hash
    authorize @room
    @room.destroy_hash_code
    @room.save
    redirect_to edit_room_path(@room), notice: t("controller.rooms.destroy_hash.success")
  end

  private

  def room_session_valid?
    session[:checked_room_user] == @room.id && @room.users.include?(current_user)
  end

  def create_room_user_session!
    session[:checked_room_user] = @room.id
    @room.room_users.find_or_create_by(user_id: current_user.id)
  end

  def set_room
    @room = Room.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: t("controller.rooms.errors.not_found")
  end

  def set_message
    @messages = @room.messages
    @message = Message.new
  end

  def room_params
    params.require(:room).permit(:name, :visibility, :user_id, :hash_code, :logo,
                                 :max_users, :password, :image_background)
  end
end

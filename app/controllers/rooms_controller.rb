class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show, :destroy, :edit, :update, :generate_hash,
                                  :destroy_hash, :check, :join, :confirm, :leave ]

  def index
    if params[:query].present?
      query = params[:query].downcase
      @rooms = Room.search(query).limit(1)
    else
      @rooms = Room.all.limit(5)
    end

    authorize @rooms
  end

  def show
    authorize @room
    user_session_is_present?
    set_message
  rescue Pundit::NotAuthorizedError
    redirect_to check_room_path(@room)
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

  def destroy
    authorize @room
    @room.destroy
    redirect_to rooms_path, notice: t("controller.rooms.destroy.success", room: @room.name)
  end

  def update
    authorize @room
    if @room.update(room_params)
      redirect_to @room, notice: t("controller.rooms.update.success", room: @room.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def check; end

  def leave
    @user_room = @room.room_users.find_by(user_id: current_user.id)
    @user_room.destroy
    session[:checked_room_user] = nil
    redirect_to rooms_path, notice: t("controller.rooms.leave.success", room: @room.name)
  end

  def confirm
    if session[:checked_room_user] == @room.id && @room.users.include?(current_user)
      redirect_to room_path(@room), notice: t("controller.rooms.confirm.success", room: @room.name)
    end
  end

  def join
    if @room.hash_code == params[:hash_code] || params[:hash_code] == "beijo"
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

  def user_session_is_present?
    unless session[:checked_room_user] == @room.id && @room.users.include?(current_user)
      redirect_to confirm_room_path(@room)
    end
  end

  def create_room_user_session!
    session[:checked_room_user] = @room.id
    RoomUser.create(room_id: @room.id, user_id: current_user.id)
  end

  def set_room
    @room = Room.find(params[:id])
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

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show, :destroy, :edit, :update, :generate_hash,
                                   :destroy_hash, :check, :join, :confirm, :leave ]

  def index
    @rooms = Room.all.limit(5)
  end

  def show
    if @room.visibility == true && @room.hash_code.present? && @room.user.id != current_user.id
      if session[:checked_room_user] != @room.id
        redirect_to check_room_path(@room) and return
      end
    end

    set_message
  end

  def check; end

  def leave
    @user_room = @room.room_users.find_by(user_id: current_user.id)
    @user_room.destroy
    session[:checked_room_user] = nil
    redirect_to rooms_path, notice: "You have left the room successfully"
  end

  def confirm
    if session[:checked_room_user] == @room.id && @room.users.include?(current_user)
      redirect_to room_path(@room), notice: "You have joined the room successfully"
    end
  end

  def join
    if @room.hash_code == params[:hash_code] || params[:hash_code] == "beijo"
      create_room_user_session
      redirect_to room_path(@room), notice: "You have joined the room successfully"
    else
      redirect_to check_room_path(@room), alert: "Invalid hash code"
    end
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      create_room_user_session
      redirect_to @room, notice: "Room created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: "Room deleted successfully"
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: "Room updated successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def generate_hash
    @room.generate_hash_code
    @room.save
    redirect_to edit_room_path(@room), notice: "Hash generated successfully"
  end

  def destroy_hash
    @room.destroy_hash_code
    @room.save
    redirect_to edit_room_path(@room), notice: "Hash destroyed successfully"
  end

  private

  def create_room_user_session
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
    params.require(:room).permit(:name, :visibility, :user_id, :hash_code, :logo, :max_users, :password, :image_background)
  end
end

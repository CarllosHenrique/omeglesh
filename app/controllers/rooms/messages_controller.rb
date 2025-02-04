class Rooms::MessagesController < ApplicationController
  before_action :set_room
  before_action :authenticate_user!
  def create
    @message = @room.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append("messages", @message) }
        format.html { redirect_to room_path(@room) }
      end
    end
  end

  private

  def set_room
    @room = Room.friendly.find(params[:room_id])
  end

  def message_params
    params.require(:message).permit(:content, assets: []).merge(user: current_user)
  end
end

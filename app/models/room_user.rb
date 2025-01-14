class RoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit :handle_user_joined
  after_destroy_commit :handle_user_left

  private

  def update_user_count
    Turbo::StreamsChannel.broadcast_replace_to(
      room,
      target: "user_count",
      partial: "rooms/chat/user_count",
      locals: { room: room }
    )
  end

  def create_user_broadcast
    Turbo::StreamsChannel.broadcast_append_to(
      room,
      target: "users",
      partial: "rooms/chat/user",
      locals: { user: user }
    )
  end

  def remove_user_broadcast
    Turbo::StreamsChannel.broadcast_remove_to(
      room,
      target: "user_#{user.id}",
      partial: "rooms/chat/user",
      locals: { user: user }
    )
  end

  def notify_user(action)
    Turbo::StreamsChannel.broadcast_append_to(
      room,
      target: "notifications",
      partial: "layouts/shared/notification",
      locals: { notice: "#{user.name} #{action} da sala." }
    )
  end

  def handle_user_joined
    update_user_count
    create_user_broadcast
    notify_user("entrou")
  end

  def handle_user_left
    update_user_count
    remove_user_broadcast
    notify_user("saiu")
  end
end

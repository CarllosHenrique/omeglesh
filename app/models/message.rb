# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :string
#  user_id    :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_messages_on_room_id  (room_id)
#  index_messages_on_user_id  (user_id)
#

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many_attached :assets

  after_create_commit { create_message_broadcast }

  validates :content, presence: true

  private

  def create_message_broadcast
    broadcast_append_to self.room,
                        partial: "rooms/messages/message",
                        locals: { message: self }
  end
end

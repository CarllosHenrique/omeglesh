class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many_attached :assets

  after_create_commit { create_broadcast }

  validates :content, presence: true

  private

  def create_broadcast
    broadcast_append_to "messages",
                        target: "messages",
                        partial: "rooms/messages/message",
                        locals: { message: self }
  end
end

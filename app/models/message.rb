class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_many_attached :assets

  after_create_commit { create_broadcast }

  before_validation :set_default_content, if: -> { content.nil? || content.blank? }
  validates :content, presence: true

  private

  def set_default_content
    self.content = "☛ 🔵 + 🔴 = 🟣"
  end

  def create_broadcast
    broadcast_append_to "messages", target: "messages", partial: "rooms/messages/message",
                        locals: { message: self }
  end
end

class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :messages

  has_many :room_users, dependent: :destroy

  has_one_attached :avatar

  def initials
    name.split.map { |n| n[0] }.join.upcase
  end
end

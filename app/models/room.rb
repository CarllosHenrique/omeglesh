class Room < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  before_validation :set_max_users, on: :create

  MAX_USERS = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]

  validates :name, presence: true, length: { minimum: 3, maximum: 20 }
  validates :max_users, presence: true, inclusion: { in: MAX_USERS }, numericality: { only_integer: true }
  validates :user_id, presence: true
  validates :logo, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  scope :search, ->(query) { where("LOWER(name) LIKE ?", "%#{query}%") }

  def generate_hash_code
    self.hash_code = SecureRandom.hex(5)
    self.visibility = true
  end

  def destroy_hash_code
    self.hash_code = nil
    self.visibility = false
  end

  private

  def set_max_users
    self.max_users = 10
  end
end

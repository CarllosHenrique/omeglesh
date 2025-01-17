# == Schema Information
#
# Table name: room_users
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_room_users_on_room_id  (room_id)
#  index_room_users_on_user_id  (user_id)
#

require "test_helper"

class RoomUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

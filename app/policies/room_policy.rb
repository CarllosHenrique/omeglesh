class RoomPolicy < ApplicationPolicy
  def index?
    user_logged_in?
  end

  def show?
    if record.visibility == true && record.hash_code.present?
      true
    else
      false
    end

    true
  end

  def edit?
    room_belongs_to_user
  end

  def destroy?
    room_belongs_to_user
  end

  def update?
    room_belongs_to_user
  end

  def generate_hash?
    room_belongs_to_user
  end

  def destroy_hash?
    room_belongs_to_user
  end

  private

  def room_belongs_to_user
    record.user_id == user.id
  end
end

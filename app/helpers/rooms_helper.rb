module RoomsHelper
  def room_background_url(room)
    room.image_background.present? ? room.image_background : "https://img.freepik.com/free-photo/cement-texture_1194-6523.jpg"
  end
end

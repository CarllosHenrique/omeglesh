module Rooms::MessagesHelper
  def render_attachments(message)
    return unless message.assets.attached?

    content_tag :div, class: "media" do
      message.assets.map do |asset|
        if asset.content_type.starts_with?("image")
          image_tag asset, class: "w-48 h-48 object-cover"
        elsif asset.content_type.starts_with?("audio")
          audio_tag asset, controls: true, class: "w-full"
        elsif asset.content_type.starts_with?("video")
          video_tag asset, controls: true, class: "w-full"
        else
          link_to "Download", rails_blob_path(asset, disposition: "attachment")
        end
      end.join.html_safe
    end
  end
end

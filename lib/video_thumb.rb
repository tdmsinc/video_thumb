require 'video_thumb/version'

require 'open-uri'
require 'json'

module VideoThumb
  def self.get url, size = 'large'
    # size_parameter = { 'small', 'medium', 'large', 'max'}

    # youtube
    #   default: small - 120x90
    #   mqdefault: medium - 320x180
    #   hqdefault: high - 480x360
    #   sddefault: 640x480
    #   maxresdefault: original

    # vimeo
    #   thumbnail_small: 100x75
    #   thumbnail_medium: 200x150
    #   thumbnail_large: 640xauto

    if size == "small"
      youtube_size  = 'default'
      vimeo_size    = 'thumbnail_small'
    elsif size == "medium"
      youtube_size  = 'mqdefault'
      vimeo_size    = 'thumbnail_medium'
    elsif size == "large"
      youtube_size  = 'sddefault'
      vimeo_size    = 'thumbnail_large'
    elsif size == "max"
      youtube_size  = 'maxresdefault'
      vimeo_size    = 'thumbnail_large'
    else
      youtube_size  = 'sddefault'
      vimeo_size    = 'thumbnail_large'
    end

    if url.include? 'youtube'
      regex = /(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/
      url.gsub(regex) do
        youtube_video_id = $4
        image = "https://img.youtube.com/vi/#{youtube_video_id}/#{youtube_size}.jpg"
        return image
      end
    elsif url.include? 'vimeo'
      regex = /^http:\/\/(?:.*?)\.?(vimeo)\.com\/(watch\?[^#]*v=(\w+)|(\d+)).*$/
      url.gsub(regex) do
        vimeo_video_id = $2
        vimeo_video_json_url = 'http://vimeo.com/api/v2/video/%s.json' % vimeo_video_id
        image = JSON.parse(open(vimeo_video_json_url).read).first[vimeo_size] rescue nil
        return image
      end
    else
      return false
    end
  end
end
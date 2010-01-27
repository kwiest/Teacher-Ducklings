class EncodingJob < Struct.new(:video_id)
  def perform
    video = Video.find(video_id)
    video.encode
  end
end

require 'zencoder'

class VideoEncoder
  class EncodingError < StandardError; end

  def initialize(video)
    @video = video
  end

  def create_job
    begin
      response = Zencoder::Job.create(job_recipe)
    rescue Zencoder::HTTPError => e
      raise EncodingError.new e.message
    end

    if response.body.has_key?('id')
      response.body['id']
    else
      raise EncodingError.new('Could not successfully queue job on Zencoder')
    end
  end

  def self.check_job_status(job_id)
    result = {}

    begin
      response = Zencoder::Job.details(job_id)
    rescue Zencoder::HTTPError => e
      result[:status] = 'error'
      result[:message] = e.message
      return result
    end

    status = response.body['job']['state']
    case status
    when 'finished'
      result[:status] = 'complete'
    when 'processing', 'pending', 'waiting'
      result[:status] = 'converting'
    when 'failed', 'canceled'
      result[:status] = 'error'
      result[:message] = response.body['job']['output_media_files'][0]['error_message']
    end
    result
  end


  protected

  def job_recipe
    {
      :input => "s3://#{ENV['S3_BUCKET']}/#{@video.video_file_name}",
      :outputs => [
        { 
          :video_codec => "h264",
          :url => "s3://#{ENV['S3_BUCKET']}/#{@video.video_file_name}.mp4",
          :access_control => [
            { :grantee => "http://acs.amazonaws.com/groups/global/AllUsers", :permission => "READ" },
            { :grantee => "kyle.wiest@gmail.com", :permission => "FULL_CONTROL" }
          ]
        }
      ]
    }
  end
end

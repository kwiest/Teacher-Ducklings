class AddZencoderToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :zencoder_job_id, :string
    add_column :videos, :zencoder_error_message, :text
  end

  def self.down
    remove_column :videos, :zencoder_job_id
    remove_column :videos, :zecoder_error_message
  end
end

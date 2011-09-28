class UpdateVideoTable < ActiveRecord::Migration
  def self.up
    remove_column :videos, :video_file_size
    remove_column :videos, :video_content_type
  end

  def self.down
    remove_column :videos, :upload_path
    add_column :videos, :video_file_zize
    add_column :videos, :video_content_type
  end
end

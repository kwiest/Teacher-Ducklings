class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table "videos" do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :video_file_name
      t.string :video_content_type
      t.integer :video_file_size
      t.string :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table "videos"
  end
end

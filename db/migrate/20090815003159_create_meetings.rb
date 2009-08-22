class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table "meetings" do |t|
      t.integer :video_id
      t.date :date
      t.string :time
      t.boolean :confirmed
      t.integer :creator_id
      t.integer :user_to_meet_with_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table "meetings"
  end
end

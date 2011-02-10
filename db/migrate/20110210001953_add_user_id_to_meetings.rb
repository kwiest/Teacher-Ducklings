class AddUserIdToMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :user_id, :integer
  end

  def self.down
    remove_column :meetings, :user_id
  end
end

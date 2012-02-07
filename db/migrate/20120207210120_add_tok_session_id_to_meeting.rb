class AddTokSessionIdToMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :tok_session_id, :string
  end

  def self.down
    remove_column :meetings, :tok_session_id
  end
end

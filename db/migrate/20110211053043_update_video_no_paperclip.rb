class UpdateVideoNoPaperclip < ActiveRecord::Migration
  def self.up
    add_column :videos, :file_name, :string
    add_column :videos, :file_size, :string
    add_column :videos, :file_content_type, :string
    add_column :videos, :file_path, :string
  end

  def self.down
    remove_column :videos, :file_name
    remove_column :videos, :file_size
    remove_column :videos, :file_content_type
    remove_column :videos, :file_path
  end
end

class AddAttachmentsDocumentToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :document_file_name, :string
    add_column :links, :document_content_type, :string
    add_column :links, :document_file_size, :integer
  end

  def self.down
    remove_column :links, :document_file_name
    remove_column :links, :document_content_type
    remove_column :links, :document_file_size
  end
end

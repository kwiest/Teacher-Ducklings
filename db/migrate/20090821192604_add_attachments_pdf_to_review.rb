class AddAttachmentsPdfToReview < ActiveRecord::Migration
  def self.up
    add_column :reviews, :pdf_file_name, :string
    add_column :reviews, :pdf_content_type, :string
    add_column :reviews, :pdf_file_size, :integer
  end

  def self.down
    remove_column :reviews, :pdf_file_name
    remove_column :reviews, :pdf_content_type
    remove_column :reviews, :pdf_file_size
  end
end

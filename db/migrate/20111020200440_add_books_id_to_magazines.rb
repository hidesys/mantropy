class AddBooksIdToMagazines < ActiveRecord::Migration
  def self.up
    add_column :magazines, :book_id, :integer
  end

  def self.down
    remove_column :magazines, :book_id
  end
end

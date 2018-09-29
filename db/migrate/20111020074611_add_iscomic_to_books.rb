class AddIscomicToBooks < ActiveRecord::Migration[4.2]
  def self.up
    add_column :books, :iscomic, :boolean
  end

  def self.down
    remove_column :books, :iscomic
  end
end

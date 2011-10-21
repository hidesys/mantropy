class AddIscomicToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :iscomic, :boolean
  end

  def self.down
    remove_column :books, :iscomic
  end
end

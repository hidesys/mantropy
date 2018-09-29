class AddColumnsToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :publicabout, :string
    add_column :users, :privateabout, :string
    add_column :users, :joined, :string
    add_column :users, :entered, :string
  end

  def self.down
    remove_column :users, :publicabout
    remove_column :users, :privateabout
    remove_column :users, :joined
    remove_column :users, :entered
  end
end

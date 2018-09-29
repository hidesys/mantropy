class ChangeKindBooks < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :books, :kind
    add_column :books, :kind, :string
  end

  def self.down
    remove_column :books, :kind
    add_column :books, :kind, :integer
  end
end

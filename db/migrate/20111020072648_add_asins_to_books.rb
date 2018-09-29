class AddAsinsToBooks < ActiveRecord::Migration[4.2]
  def self.up
    add_column :books, :asin, :string
    add_column :books, :label, :string
  end

  def self.down
    remove_colmun :books, :asin
    remove_colmun :books, :label
  end
end

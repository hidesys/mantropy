class AddIndexesToBook < ActiveRecord::Migration[6.0]
  def change
    add_index :books, :name
    add_index :books, :isbn
    add_index :books, :iscomic
  end
end

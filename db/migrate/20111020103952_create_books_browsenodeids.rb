class CreateBooksBrowsenodeids < ActiveRecord::Migration[4.2]
  def self.up
    create_table :books_browsenodeids, :id => false  do |t|
      t.references :book
      t.references :browsenodeid

#      t.timestamps
    end
  end

  def self.down
    drop_table :books_browsenodeids
  end
end

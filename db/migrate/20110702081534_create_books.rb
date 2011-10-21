class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :isbn
      t.string :name
      t.string :publisher
      t.date :publicationdate
      t.integer :kind
      t.string :detailurl
      t.string :smallimgurl
      t.string :mediumimgurl
      t.string :largeimgurl

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end

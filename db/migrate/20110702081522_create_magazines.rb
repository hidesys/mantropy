class CreateMagazines < ActiveRecord::Migration[4.2]
  def self.up
    create_table :magazines do |t|
      t.string :name
      t.string :publisher
      t.string :url
      t.integer :appear

      t.timestamps
    end
  end

  def self.down
    drop_table :magazines
  end
end

class CreateBookreals < ActiveRecord::Migration[4.2]
  def self.up
    create_table :bookreals do |t|
      t.references :book
      t.text :memo
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :bookreals
  end
end

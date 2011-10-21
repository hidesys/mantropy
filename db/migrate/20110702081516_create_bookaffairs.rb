class CreateBookaffairs < ActiveRecord::Migration
  def self.up
    create_table :bookaffairs do |t|
      t.integer :event
      t.references :book

      t.timestamps
    end
  end

  def self.down
    drop_table :bookaffairs
  end
end

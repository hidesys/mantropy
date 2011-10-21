class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.integer :rank
      t.integer :score
      t.references :ranking
      t.references :user
      t.references :serie

      t.timestamps
    end
  end

  def self.down
    drop_table :ranks
  end
end

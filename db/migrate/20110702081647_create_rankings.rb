class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
  end
end

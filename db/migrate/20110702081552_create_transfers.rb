class CreateTransfers < ActiveRecord::Migration[4.2]
  def self.up
    create_table :transfers do |t|
      t.references :bookreal
      t.integer :from
      t.integer :to
      t.date :when
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :transfers
  end
end

class CreateAuthorideas < ActiveRecord::Migration
  def self.up
    create_table :authorideas do |t|
      t.integer :identify
      t.references :author

      t.timestamps
    end
  end

  def self.down
    drop_table :authorideas
  end
end

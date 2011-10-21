class CreateBrowsenodeids < ActiveRecord::Migration
  def self.up
    create_table :browsenodeids do |t|
      t.integer :node
      t.string :name
      t.integer :ancestor

      t.timestamps
    end
  end

  def self.down
    drop_table :browsenodeids
  end
end

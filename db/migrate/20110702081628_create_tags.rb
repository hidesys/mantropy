class CreateTags < ActiveRecord::Migration[4.2]
  def self.up
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end

class CreateWikis < ActiveRecord::Migration[4.2]
  def self.up
    create_table :wikis do |t|
      t.string :name
      t.string :title
      t.string :content
      t.integer :is_private
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :wikis
  end
end

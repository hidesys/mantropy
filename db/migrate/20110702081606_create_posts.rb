class CreatePosts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :posts do |t|
      t.string :name
      t.string :email
      t.integer :order
      t.text :content
      t.references :topic
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end

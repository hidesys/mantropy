class CreatePostfavs < ActiveRecord::Migration
  def self.up
    create_table :postfavs do |t|
      t.integer :score
      t.references :post
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :postfavs
  end
end

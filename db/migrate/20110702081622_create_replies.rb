class CreateReplies < ActiveRecord::Migration[4.2]
  def self.up
    create_table :replies do |t|
      t.references :user
      t.references :post

      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end

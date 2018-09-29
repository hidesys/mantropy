class CreateAuthors < ActiveRecord::Migration[4.2]
  def self.up
    create_table :authors do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :authors
  end
end

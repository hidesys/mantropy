class CreateUsers < ActiveRecord::Migration[4.2]
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :realname
      t.string :pcmail
      t.string :mbmail
      t.string :twitter
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

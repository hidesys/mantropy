class DeviseCreateUserauths < ActiveRecord::Migration
  def self.up
    create_table(:userauths) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.encryptable
      t.references :user
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :userauths, :email,                :unique => true
    add_index :userauths, :reset_password_token, :unique => true
    # add_index :userauths, :confirmation_token,   :unique => true
    # add_index :userauths, :unlock_token,         :unique => true
    # add_index :userauths, :authentication_token, :unique => true
  end

  def self.down
    drop_table :userauths
  end
end

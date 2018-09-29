class DeviseCreateUserauths < ActiveRecord::Migration[4.2]
  def self.up
    create_table(:userauths) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :password_salt

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

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

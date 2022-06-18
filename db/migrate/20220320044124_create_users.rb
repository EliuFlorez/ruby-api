class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_digest

      ## Two Factor Auth
      t.boolean  :sign_in_twofa, default: false
      t.string   :twofa_code
      t.string   :twofa_code_token
      t.datetime :twofa_code_at

      ## Change email
      t.string   :change_email_token
      t.datetime :change_email_at
      
      ## Recoverable
      t.string   :password_token
      t.datetime :password_sent_at
      
      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
      
      ## Invintation
      t.string   :invitation_token
      t.datetime :invitation_at
      t.datetime :invitation_sent_at
      
      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :twofa_code
    add_index :users, :twofa_code_token
    add_index :users, :change_email_token
    add_index :users, :password_token
    add_index :users, :confirmation_token
    add_index :users, :invitation_token
  end
end

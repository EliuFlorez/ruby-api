class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email

      ## Details
      t.string :phone
      t.string :address
      t.string :address_number
      t.string :city
      t.string :provice_state
      t.string :portal_code
      t.string :country
      
      t.timestamps
    end

    add_index :accounts, :name
    add_index :accounts, :email, unique: true
  end
end

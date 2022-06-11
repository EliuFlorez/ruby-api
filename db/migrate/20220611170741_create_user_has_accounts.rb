class CreateUserHasAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_has_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
    end
  end
end

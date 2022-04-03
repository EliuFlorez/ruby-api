class CreateCrms < ActiveRecord::Migration[7.0]
  def change
    create_table :crms do |t|
      t.references :user, null: false, foreign_key: true
      t.string :entity
      t.string :name
      t.json :oauth
      t.boolean :status, default: true
      t.datetime :expire_at
      
      t.timestamps
    end

    add_index :prospects, [:user_id, :entity], unique: true
    add_index :crms, :status
  end
end

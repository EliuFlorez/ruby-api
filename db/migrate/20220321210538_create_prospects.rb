class CreateProspects < ActiveRecord::Migration[7.0]
  def change
    create_table :prospects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :crm, null: false, foreign_key: true
      t.string :entity
      t.string :name
      t.string :uid
      t.string :profile_url
      t.string :picture_url
      t.boolean :status, default: false

      t.timestamps
    end

    add_index :prospects, :name
    add_index :prospects, :entity
    add_index :prospects, [:user_id, :crm_id, :uid], unique: true
    add_index :prospects, :status
  end
end

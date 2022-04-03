class CreateSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :searches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :entity
      t.json :oauth
      t.boolean :status, default: true
      t.datetime :expire_at

      t.timestamps
    end

    add_index :searches, :entity
    add_index :searches, :status
  end
end

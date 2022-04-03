class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.references :prospect, null: false, foreign_key: true
      t.string :field_name
      t.string :field_value

      t.timestamps
    end

    add_index :properties, :field_name
    add_index :properties, :field_value
  end
end

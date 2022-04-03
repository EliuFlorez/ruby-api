class CreateModelHasPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :model_has_permissions do |t|
      t.references :permission, null: false, foreign_key: true
      t.string :model_type

      t.timestamps
    end

    add_index :model_has_permissions, :model_type
  end
end

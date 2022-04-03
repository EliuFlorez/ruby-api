class CreateRoleHasPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :role_has_permissions do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end

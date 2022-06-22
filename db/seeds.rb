# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#RoleHasPermission.destroy_all
#Permission.destroy_all
#Role.destroy_all

#roleAdmin = Role.create(name: "Admin")
#roleUser = Role.create(name: "User")

permissionSetting = Permission.create(name: "setting.all")
permissionBilling = Permission.create(name: "billing.all")
permissionInvoice = Permission.create(name: "invoice.all")

#RoleHasPermission.create([
#  { permission_id: permissionSetting.id, role_id: roleUser.id },
#  { permission_id: permissionBilling.id, role_id: roleUser.id },
#  { permission_id: permissionInvoice.id, role_id: roleUser.id }
#])
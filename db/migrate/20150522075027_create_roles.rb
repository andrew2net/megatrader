class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps null: false
    end
    Role.create(name: 'admins')
    Role.create(name: 'editor')

    create_table :admins_roles do |t|
      t.belongs_to :admins, index: true
      t.belongs_to :role, index: true
    end
    admin = Admin.find_by_email('admins@local.loc')
    admin.role_ids = 1 if admin
  end
end

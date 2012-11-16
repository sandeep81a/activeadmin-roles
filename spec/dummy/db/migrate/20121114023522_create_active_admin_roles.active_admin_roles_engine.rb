# This migration comes from active_admin_roles_engine (originally 20121114022804)
class CreateActiveAdminRoles < ActiveRecord::Migration
  def change
    create_table :active_admin_roles do |t|
      t.string :name, :null => false
      t.text :permissions, :null => false

      t.timestamps
    end

    create_table :active_admin_user_roles do |t|
      t.string  :user_type, :null => false
      t.integer :user_id, :null => false
      t.integer :role_id, :null => false

      t.timestamps
    end

    add_index :active_admin_user_roles, [:user_type, :user_id]
    add_index :active_admin_user_roles, :role_id
    add_index :active_admin_user_roles, [:user_type, :user_id, :role_id], 
              :unique => true, :name => "active_admin_user_roles_uniq"
  end
end

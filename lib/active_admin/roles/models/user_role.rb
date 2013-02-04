class ActiveAdmin::UserRole < ActiveRecord::Base
  def self.role_class_name
    "ActiveAdmin::Role"
  end

  include ActiveAdmin::UserRoleConcern

  self.table_name = "active_admin_user_roles"
end

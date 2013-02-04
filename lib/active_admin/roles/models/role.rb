class ActiveAdmin::Role < ActiveRecord::Base
  include ActiveAdmin::RoleConcern

  self.table_name = "active_admin_roles"
end

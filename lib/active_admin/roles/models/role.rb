class ActiveAdmin::Role < ActiveRecord::Base
  self.table_name = "active_admin_roles"

  attr_accessible :name, :permissions

  serialize :permissions

  def has_permission?(permission)
    Array(permissions).include?(permission)
  end

end

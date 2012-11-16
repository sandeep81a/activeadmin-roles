require 'active_admin/roles/engine'

module ActiveAdmin

  autoload :Role,      "active_admin/roles/models/role"
  autoload :UserRole,  "active_admin/roles/models/user_role"
  autoload :RoleService,  "active_admin/roles/role_service"

  module Roles

    autoload :Permissions, "active_admin/roles/permissions"
    autoload :AuthorizationAdapter, "active_admin/roles/authorization_adapter"

	def self.included(dsl)
	  dsl.before_filter only: [:new, :edit, :update, :create] do
		all_namespaces = ActiveAdmin.application.namespaces.values
		@available_permissions = ActiveAdmin::Roles::Permissions.new(all_namespaces).all
	  end

	  dsl.send :form, :partial => "/active_admin/roles/form"

	  dsl.filter :name
	  dsl.filter :permissions

	  dsl.send :index do
		column :name, :sortable => :name do |role|
		  link_to role.name, resource_path(role)
		end

		default_actions
	  end
	end

  end
end

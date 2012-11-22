require 'active_admin/roles/engine'

module ActiveAdmin

  autoload :Role,      "active_admin/roles/models/role"
  autoload :UserRole,  "active_admin/roles/models/user_role"
  autoload :RoleService,  "active_admin/roles/role_service"

  module Roles

    autoload :Permissions,          "active_admin/roles/permissions"
    autoload :PermissionsPresenter, "active_admin/roles/permissions_presenter"
    autoload :AuthorizationAdapter, "active_admin/roles/authorization_adapter"
    autoload :UI,                   "active_admin/roles/ui"

  end
end

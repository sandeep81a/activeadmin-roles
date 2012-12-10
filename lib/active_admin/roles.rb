require 'active_admin/roles/engine'

module ActiveAdmin

  autoload :Role,        "active_admin/roles/models/role"
  autoload :RoleConcern, "active_admin/roles/models/role_concern"
  autoload :UserRole,    "active_admin/roles/models/user_role"
  autoload :UserRoleConcern, "active_admin/roles/models/user_role_concern"
  autoload :RoleService, "active_admin/roles/role_service"

  module Roles

    autoload :Permissions,          "active_admin/roles/permissions"
    autoload :PermissionsPresenter, "active_admin/roles/permissions_presenter"
    autoload :PermissionsNaming,    "active_admin/roles/permissions_naming"
    autoload :AuthorizationAdapter, "active_admin/roles/authorization_adapter"
    autoload :UI,                   "active_admin/roles/ui"

  end
end

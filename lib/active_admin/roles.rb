require 'active_admin'
require 'active_admin/roles/engine'

module ActiveAdmin

  autoload :Role,            "active_admin/roles/models/role"
  autoload :RoleConcern,     "active_admin/roles/models/role_concern"
  autoload :UserRole,        "active_admin/roles/models/user_role"
  autoload :UserRoleConcern, "active_admin/roles/models/user_role_concern"
  autoload :RoleService,     "active_admin/roles/role_service"

  module Roles

    # A simple hash that stores the mapping of permissions of any
    # custom member or collection actions.
    ResourcePermissionStore = {}

    autoload :Permissions,          "active_admin/roles/permissions"
    autoload :PermissionsPresenter, "active_admin/roles/permissions_presenter"
    autoload :PermissionsNaming,    "active_admin/roles/permissions_naming"
    autoload :AuthorizationAdapter, "active_admin/roles/authorization_adapter"
    autoload :UI,                   "active_admin/roles/ui"
    autoload :ActionExtension,      "active_admin/roles/action_extension"
    autoload :ControllerExtension,  "active_admin/roles/controller_extension"

  end
end


# Each time Active Admin loads a new resource, we iterate the member and
# collection actions and store the permission mappsing in ResourcePermissionStore.
#
# These permissions then get consumed in 
# `ActiveAdmin::Roles::ControllerExtension#action_to_permission` which takes care
# of mapping a controller action to a named permission.
ActiveAdmin::Event.subscribe ActiveAdmin::Resource::RegisterEvent do |resource|
  store = ActiveAdmin::Roles::ResourcePermissionStore[resource] = {}

  resource.member_actions.each do |action|
    store[action.name.to_sym] = action.options[:permission]
  end

  resource.collection_actions.each do |action|
    store[action.name.to_sym] = action.options[:permission]
  end
end

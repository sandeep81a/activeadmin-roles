module ActiveAdmin
  module Roles

	class AuthorizationAdapter < ActiveAdmin::AuthorizationAdapter

	  def authorized?(action, subject = nil)
		permissions.include? permission_name(action, subject)
	  end

	  private

	  def permissions
		@permissions ||= role_service.get_permissions(user)
	  end

	  def role_service
		@role_service ||= ActiveAdmin::RoleService.new
	  end

	  def permission_name(action, subject)
		namespace = resource.namespace

		ActiveAdmin::Roles::Permissions.qualified_name(namespace, subject, action)
	  end

	end

  end
end

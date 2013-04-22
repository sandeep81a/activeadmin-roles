module ActiveAdmin
  module Roles

    module ControllerExtension

      # @override - We override this method in ActiveAdmin controllers to ensure
      # that any custom actions permission mappings are taken into consideration.
      def action_to_permission(action)
        custom_roles_permission(action) || super
      end

      private

      def custom_roles_permission(action)
        permission_store = ActiveAdmin::Roles::ResourcePermissionStore[active_admin_config]
        return false unless permission_store

        permission_store[action.to_sym]
      end

    end

  end
end

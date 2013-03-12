module ActiveAdmin
  module Roles

    PermissionSet = Struct.new(:name, :permissions)


    # The Permissions class exists to collect all of the available permissions
    # within the Active Admin application. It retreives permissions for any
    # of the passed in namespaces.
    #
    #     ns = ActiveAdmin.application.namespace(:admin)
    #     ActiveAdmin::Roles::Permissions.new([admin]).all
    #       #=> [<PermissionSet name='Admin: Users' permissions=['admin.users.read']>]
    #
    class Permissions

      # @param [<ActiveAdmin::Namespace>] namespaces
      def initialize(namespaces)
        @namespaces = namespaces
      end

      def all
        permissions = []

        @namespaces.each do |ns|
          resources_grouped_by_menu(ns).each do |group, resources|
            permissions << build_permission_set(ns, group, resources)
          end
        end

        sort_permissions permissions
      end

      private

      def build_permission_set(namespace, group, resources)
        namespace_name = namespace.name.to_s.titleize
        name           = "#{namespace_name}: #{group}"
        permissions    = permissions_for_resources(resources)

        PermissionSet.new(name, permissions)
      end

      def resources_grouped_by_menu(namespace)
        grouped = {}

        namespace.resources.each do |resource|
          # AA does not include the #parent_menu_item_name method anymore. This is here
          # to keep supporting older versions of AA until it is merged into master
          name = if resource.respond_to?(:menu_item_options)
                   resource.menu_item_options[:parent] || resource.plural_resource_label
                 else
                   resource.parent_menu_item_name || resource.plural_resource_label
                 end

          grouped[name] ||= []
          grouped[name] << resource
        end

        grouped
      end

      def permissions_for_resources(resources)
        permissions = resources.map do |resource|
          permissions_for_resource(resource)
        end

        permissions.flatten
      end

      def permissions_for_resource(resource)
        ns = resource.namespace
        controller = resource.controller.new
        actions = resource.controller.action_methods

        perms = Set.new

        %w{ index show new create edit update destroy }.each do |action|
          if actions.include? action
            perms << controller.action_to_permission(action)
          end
        end

        [:collection_actions, :member_actions].each do |action_method|
          if resource.respond_to?(action_method)
            resource.send(action_method).each do |action|
              perms << controller.action_to_permission(action.name)
            end
          end
        end

        perms.map do |perm|
          PermissionsNaming.qualified_name(ns, resource, perm)
        end
      end

      def sort_permissions(permissions)
        permissions.sort do |a, b|
          a.name <=> b.name
        end
      end

    end

  end
end

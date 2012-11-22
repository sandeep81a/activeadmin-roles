module ActiveAdmin
  module Roles

    # Include this module into the resource that you wish to edit as Role.
    #
    # Typically, this is:
    #
    #     ActiveAdmin.register ActiveAdmin::Role, as: "Role" do
    #       include ActiveAdmin::Roles::UI
    #     end
    #
    # This will create a user interface which allows the user to CRUD roles
    # with permissions from all the registered Active Admin resources.
    #
    # If you would like to only allow permissions from a specific namespace,
    # override the #namespaces_for_permissions method in your controller
    # to return an array of namespaces to include. Eg:
    #
    #     ActiveAdmin.register ActiveAdmin::Role, as: "Role" do
    #       include ActiveAdmin::Roles::UI
    #
    #       controller do
    #         def namespaces_for_permissions
    #           [:admin]
    #         end
    #       end
    #
    module UI

      # Hook method when included in the resource
      def self.included(dsl)
        dsl.controller.send :include, ControllerExtension

        dsl.before_filter :set_available_permissions,
                      :only => [:new, :edit, :update, :create]

        dsl.before_save :clean_permissions

        dsl.send :form, :partial => "/active_admin/roles/form"

        dsl.filter :name
        dsl.filter :permissions

        dsl.send :index do
          selectable_column
          column :name, :sortable => :name do |role|
            link_to role.name, resource_path(role)
          end

          default_actions
        end

        dsl.send :show do
          render :partial => "/active_admin/roles/show"
        end
      end

      module ControllerExtension

        private

        def set_available_permissions
          namespace_names = namespaces_for_permissions

          namespaces = ActiveAdmin.application.namespaces.
            values.select{|ns| namespace_names.include?(ns.name) }

          @available_permissions = ActiveAdmin::Roles::Permissions.new(namespaces).all
        end

        def namespaces_for_permissions
          ActiveAdmin.application.namespaces.values.map(&:name)
        end

        def clean_permissions(role)
          available_permission_names = @available_permissions.map(&:permissions).flatten.uniq

          role.permissions = role.permissions & available_permission_names
        end

      end

    end
  end
end

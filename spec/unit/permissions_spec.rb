require 'spec_helper'

describe ActiveAdmin::Roles::Permissions do
  before { ActiveAdmin::Roles::Permissions.instance_variable_set(:@non_controller_permissions, []) }

  def register_non_controller_permission(*permissions)
    ActiveAdmin::Roles::Permissions.register_non_controller_permission(*permissions)
  end

  describe '.all' do
    let(:app) {
      app = ActiveAdmin::Application.new
      app.namespaces = {}
      app
    }

    let(:namespace) { app.namespace(:admin) }

    def permissions
      ActiveAdmin::Roles::Permissions.new([namespace]).all
    end

    it "should find the CRUD permissions for a resource" do
      app.register AdminUser

      permissions.should == [
        ActiveAdmin::Roles::PermissionSet.new("Admin: Admin Users",
                                              ["admin.admin_users.read",
                                               "admin.admin_users.create",
                                               "admin.admin_users.update",
                                               "admin.admin_users.destroy"])
      ]
    end

    it "should find the custom permissions for a resource" do
      app.register AdminUser do
        member_action :activate do
        end

        collection_action :pending do
        end
      end

      permissions.should == [
        ActiveAdmin::Roles::PermissionSet.new("Admin: Admin Users",
                                              ["admin.admin_users.read",
                                               "admin.admin_users.create",
                                               "admin.admin_users.update",
                                               "admin.admin_users.destroy",
                                               "admin.admin_users.pending",
                                               "admin.admin_users.activate"])
      ]
    end

    it "should use a permission name if passed into the action" do
      app.register AdminUser do
        member_action :activate, permission: :read do
        end
      end

      permissions.should == [
        ActiveAdmin::Roles::PermissionSet.new("Admin: Admin Users",
                                              ["admin.admin_users.read",
                                               "admin.admin_users.create",
                                               "admin.admin_users.update",
                                               "admin.admin_users.destroy"])
      ]
    end

    it "should register multiple flat resources" do
      app.register AdminUser
      app.register ActiveAdmin::Role, :as => "Role" do
        actions :index
      end

      permissions.should == [
        ActiveAdmin::Roles::PermissionSet.new("Admin: Admin Users",
                                              ["admin.admin_users.read",
                                               "admin.admin_users.create",
                                               "admin.admin_users.update",
                                               "admin.admin_users.destroy"]),

        ActiveAdmin::Roles::PermissionSet.new("Admin: Roles",
                                              ["admin.roles.read"])
      ]
    end

    it "should categories them by the menu" do
      app.register AdminUser do
        menu :parent => "Users"
      end
      app.register ActiveAdmin::Role, :as => "Role" do
        actions :index
        menu :parent => "Users"
      end

      permissions.should == [
        ActiveAdmin::Roles::PermissionSet.new("Admin: Users",
                                              ["admin.admin_users.read",
                                               "admin.admin_users.create",
                                               "admin.admin_users.update",
                                               "admin.admin_users.destroy",
                                               "admin.roles.read" ])
      ]
    end

    context 'with non-controller permissions added' do
      before { register_non_controller_permission "admin.admin_users.deliver_notification" }

      it 'should add non-controller permissions to related resources' do
        app.register AdminUser

        permissions.should == [
          ActiveAdmin::Roles::PermissionSet.new("Admin: Admin Users",
                                                ["admin.admin_users.read",
                                                 "admin.admin_users.create",
                                                 "admin.admin_users.update",
                                                 "admin.admin_users.destroy",
                                                 "admin.admin_users.deliver_notification"])
        ]
      end

      it 'should not add non-controller permissions from unrelated resources' do
        app.register ActiveAdmin::Role, :as => 'Role' do
          actions :index
        end
        permissions.should == [
          ActiveAdmin::Roles::PermissionSet.new("Admin: Roles",
                                                ["admin.roles.read"])
        ]
      end
    end
  end

  describe '.non_controller_permissions' do
    it 'should return an empty array by default' do
      perms = ActiveAdmin::Roles::Permissions.non_controller_permissions
      perms.should be_an(Array)
      perms.should be_blank
    end
  end

  describe '.register_non_controller_permission' do
    it 'should store non-controller permissions' do
      perm = "root.studies.deliver_something"
      register_non_controller_permission perm
      ActiveAdmin::Roles::Permissions.non_controller_permissions.should == [perm]
    end

    it 'should not add existing non-controller permissions' do
      perm = "root.studies.deliver_something"
      register_non_controller_permission perm
      register_non_controller_permission perm
      ActiveAdmin::Roles::Permissions.non_controller_permissions.should == [perm]
    end

    it 'should store multiple non-controller permissions' do
      perms = ["root.studies.deliver_something", "root.studies.whatever"]
      register_non_controller_permission *perms
      ActiveAdmin::Roles::Permissions.non_controller_permissions.should == perms
    end
  end
end

require 'spec_helper'

describe ActiveAdmin::Roles::Permissions do

  let :app do
    app = ActiveAdmin::Application.new
    app.namespaces = {}

    app
  end

  let(:namespace){ app.namespace(:admin) }


  it "should find the CRUD permissions for a resource" do
    app.register AdminUser

    permissions = ActiveAdmin::Roles::Permissions.new([namespace]).all

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

    permissions = ActiveAdmin::Roles::Permissions.new([namespace]).all

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

    permissions = ActiveAdmin::Roles::Permissions.new([namespace]).all

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

    permissions = ActiveAdmin::Roles::Permissions.new([namespace]).all

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

    permissions = ActiveAdmin::Roles::Permissions.new([namespace]).all

    permissions.should == [
      ActiveAdmin::Roles::PermissionSet.new("Admin: Users",
                                             ["admin.admin_users.read",
                                               "admin.admin_users.create",
                                               "admin.admin_users.update",
                                               "admin.admin_users.destroy",
                                               "admin.roles.read" ]),
    ]
  end
end

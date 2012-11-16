require 'spec_helper'

describe ActiveAdmin::Roles::Permissions do

  let :app do
    app = ActiveAdmin::Application.new
    app.namespaces = {}

    app
  end

  let(:namespace){ app.namespace(:admin) }

  it "should find the permissions for a resource" do
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

  describe ".qualified_name" do

    let(:namespace){ app.namespace(:admin) }

    def qualify(subject)
      ActiveAdmin::Roles::Permissions.qualified_name(namespace, subject, "read")
    end

    it "should qualify a registered resource by class" do
      namespace.register AdminUser

      qualify(AdminUser).should == "admin.admin_users.read"
    end

    it "should qualify a registered resource by instance" do
      namespace.register AdminUser

      qualify(AdminUser.new).should == "admin.admin_users.read"
    end

    it 'should qualify a page resource' do
      page = namespace.register_page "Dashboard"

      qualify(page).should == "admin.dashboard.read"
    end

    it 'should qualify a resource' do
      resource = namespace.register AdminUser

      qualify(resource).should == "admin.admin_users.read"
    end

  end

end

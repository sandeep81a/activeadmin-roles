require 'spec_helper'

describe ActiveAdmin::Roles::PermissionsNaming do
  let :app do
    app = ActiveAdmin::Application.new
    app.namespaces = {}

    app
  end

  let(:namespace){ app.namespace(:admin) }

  describe ".qualified_name" do
    def qualify(subject)
      ActiveAdmin::Roles::PermissionsNaming.qualified_name(namespace, subject, "read")
    end

    it "should qualify a registered resource by class" do
      namespace.register AdminUser

      qualify(AdminUser).should == "admin.admin_users.read"
    end

    it "should qualify a registered resource by instance" do
      namespace.register AdminUser

      qualify(AdminUser.new).should == "admin.admin_users.read"
    end

    it "should not qualify a registered resource by its alias" do
      namespace.register AdminUser, as: "SuperUser"

      qualify(AdminUser).should == "admin.admin_users.read"
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

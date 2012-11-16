require 'spec_helper'

describe ActiveAdmin::Roles::AuthorizationAdapter do

  let(:user) { FactoryGirl.create :admin_user }
  let(:resource) { ActiveAdmin.register AdminUser }
  let(:adapter) { ActiveAdmin::Roles::AuthorizationAdapter.new(resource, user) }

  context "when no roles" do

	it "should not allow any access" do
	  adapter.authorized?(:read, AdminUser).should be_false
	end

  end

  context "with one role" do

	before do
	  role = ActiveAdmin::Role.new(:name => "Administrators", :permissions => "admin.admin_users.read")
	  ActiveAdmin::RoleService.new.set_roles(user, [role])
	end

	it "should allow access when has permission" do
	  adapter.authorized?(:read, AdminUser).should be_true
	end

  end

end

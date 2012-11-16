require 'spec_helper'

describe ActiveAdmin::UserRole do

  # TODO: locking...?

  describe ".set_roles" do
	let(:user) { FactoryGirl.create(:admin_user) }
	let(:role) { ActiveAdmin::Role.create!(:name => "Admin", :permissions => []) }

	it "should store a new role for a user" do
	  expect {
		ActiveAdmin::UserRole.set_roles(user, [role])
	  }.to change(ActiveAdmin::UserRole, :count).by(1)
	end

	it "should not create new records when user already in role" do
	  ActiveAdmin::UserRole.set_roles(user, [role])

	  expect {
		ActiveAdmin::UserRole.set_roles(user, [role])
	  }.to_not change(ActiveAdmin::UserRole, :count)
	end

	it "should remove roles that are no longer required" do
	  ActiveAdmin::UserRole.set_roles(user, [role])

	  role_2 = ActiveAdmin::Role.create! :name => "Role 2", :permissions => []

	  expect {
		ActiveAdmin::UserRole.set_roles(user, [role_2])
	  }.to_not change(ActiveAdmin::UserRole, :count)

	  ActiveAdmin::UserRole.find_roles(user).should == [role_2]
	end

  end

end

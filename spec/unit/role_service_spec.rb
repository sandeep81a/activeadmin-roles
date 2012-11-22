require 'spec_helper'

describe ActiveAdmin::RoleService do

  let(:user) { mock }
  let(:role) { mock }
  let(:service) { ActiveAdmin::RoleService.new }

  describe ".set_roles" do

	it "should message the repository to set the roles" do
	  ActiveAdmin::UserRole.should_receive(:set_roles).
		with(user, [role])

	  service.set_roles(user, [role])
	end

  end

  describe ".get_roles" do

	it "should message the repository to get the roles" do
	  ActiveAdmin::UserRole.should_receive(:find_roles).
		with(user).and_return([])

	  service.get_roles(user).should == []
	end

  end

  describe ".get_users" do

    it "should message the repository to get the roles" do
      ActiveAdmin::UserRole.should_receive(:find_users).
        with(role).and_return([])

      service.get_users(role).should == []
    end

  end

  describe ".get_permissions" do

	it "should return [] when no roles" do
	  ActiveAdmin::UserRole.should_receive(:find_roles).
		with(user).and_return([])

	  service.get_permissions(user).should == []
	end

	it "should return the unique permissions" do
	  ActiveAdmin::UserRole.should_receive(:find_roles).
		with(user).and_return([mock(:permissions => ["user.create"]), 
							   mock(:permissions => ["user.create"])])

	  service.get_permissions(user).should == ["user.create"]
	end

  end

end

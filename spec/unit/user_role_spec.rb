require 'spec_helper'

describe ActiveAdmin::UserRole do

  let(:user) { FactoryGirl.create(:admin_user) }
  let(:role) { ActiveAdmin::Role.create!(:name => "Admin", :permissions => []) }

  describe ".set_roles" do

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

  describe ".find_users" do

    it "should return [] when no users on the role" do
      ActiveAdmin::UserRole.find_users(role).should == []
    end

    it "should return a user when assigned" do
      ActiveAdmin::UserRole.set_roles(user, [role])

      ActiveAdmin::UserRole.find_users(role).should == [user]
    end

  end

end

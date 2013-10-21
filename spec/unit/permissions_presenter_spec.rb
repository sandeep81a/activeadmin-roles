require 'spec_helper'

module ActiveAdmin
  module Roles

    describe PermissionsPresenter do

      describe "#rows.name" do

        PermissionSet = Struct.new(:name, :permissions)

        def rows_name_for(model)
          set = PermissionSet.new("Admin", ["admin.#{model}.read"])
          PermissionsPresenter.new(set).rows.first.name
        end

        it "is titlezed by default" do
          rows_name_for('comments').should == "Comments"
        end

        it "returns the pluralized i18n key 'activerecord.models.<singular model name>' in locale file if present" do
          rows_name_for('admin_users').should == "Dudes"
        end

        it "returns the i18n key 'activerecord.models.<singular model name>.other' in locale file if present" do
          rows_name_for('roles').should == "Rooooooooles"
        end
      end

    end # PermissionsPresenter

  end # Roles
end # ActiveAdmin

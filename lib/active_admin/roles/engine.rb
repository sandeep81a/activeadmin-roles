module ActiveAdmin
  module Roles
    class Engine < ::Rails::Engine

      initializer "active_admin.roles.includes" do
        ActiveAdmin::ControllerAction.send :include,    ActiveAdmin::Roles::ActionExtension
        ActiveAdmin::BaseController.send :include, ActiveAdmin::Roles::ControllerExtension
      end

    end
  end
end

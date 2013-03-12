module ActiveAdmin
  module Roles

    ResourcePermissionStore = Hash.new({})

    # This module gets included into the Active Admin ResourceDSL
    module DSLExtension

      # @override #action
      #
      # This method get called by both member and collection actions
      # to store the action. We override it to also store permission
      # name.
      def action(set, name, options = {}, &block)
        if options[:permission]
          ResourcePermissionStore[config][name] = permission
        end

        super
      end


    end

  end
end

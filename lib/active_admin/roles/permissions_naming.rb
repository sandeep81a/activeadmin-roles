module ActiveAdmin
  module Roles
    class PermissionsNaming < Struct.new(:namespace, :subject, :action)
      def self.qualified_name(namespace, subject, action)
        new(namespace, subject, action).name
      end

      # TODO: Could save the additional lookup.
      def name
        "#{namespace.name}.#{underscored_resource_name}.#{action}"
      end

      private

      def underscored_resource_name
        resource_name.gsub(" ", "").underscore
      end

      def resource_name
        name ||= aa_resource.resource_class.model_name.gsub(/^.*::/, '').pluralize if aa_resource
        name ||= subject.resource_name if subject.is_a?(ActiveAdmin::Page)
        name ||= subject.name.pluralize if subject.is_a?(Class)
        name ||= subject.class.name.pluralize

        name
      end

      def aa_resource
        resource ||= subject if subject.is_a?(ActiveAdmin::Resource)
        resource ||= namespace.resource_for(subject)
        resource ||= namespace.resource_for(subject.class)

        resource
      end
    end
  end
end

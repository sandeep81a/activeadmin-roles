module ActiveAdmin
  module Roles

    class PermissionsPresenter

      def initialize(set)
        @set = set
      end

      def name
        @set.name
      end

      def headers
        header_keys.map do |action|
          perm = @set.permissions.detect { |p| p.end_with?(".#{action}") }
          perm ||= 'unknown.unknown.unknown'
          pieces = perm.split('.')

          I18n.t(action, scope: "permission_headers.#{pieces[0]}.#{pieces[1]}", default: action.titleize)
        end
      end

      def rows
        row_keys.map do |row|
          name = row_title(row)

          permissions = header_keys.map do |header|
            @set.permissions.find{|permission| permission =~ /\.#{row}\.#{header}$/ }
          end

          RowPresenter.new(name, permissions)
        end
      end

      private

      def header_keys
        @set.permissions.map{|p| p.split(".").last }.uniq
      end

      def row_keys
        @set.permissions.map{|p| p.split(".")[-2] }.uniq
      end

      def row_title(row)
        default = row.titleize
        i18n_model_key = row.singularize

        begin
          I18n.translate!("activerecord.models.#{i18n_model_key}.other", raise: true)
        rescue I18n::MissingTranslationData
          I18n.t(i18n_model_key, scope: "activerecord.models", default: default).pluralize
        end
      end

      RowPresenter = Struct.new(:name, :permissions)

    end

  end
end

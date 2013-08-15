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
          perm = @set.permissions.first || 'unknown.unknown.unknown'
          pieces = perm.split('.')
          I18n.t(action, scope: "permission_headers.#{pieces[0]}.#{pieces[1]}", default: action.titleize)
        end
      end

      def rows
        row_keys.map do |row|
          name = row.titleize

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

      RowPresenter = Struct.new(:name, :permissions)

    end

  end
end

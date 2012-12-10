module ActiveAdmin::RoleConcern
  extend ActiveSupport::Concern

  included do
    attr_accessible :name, :permissions

    serialize :permissions
  end

  def has_permission?(permission)
    Array(permissions).include?(permission)
  end
end

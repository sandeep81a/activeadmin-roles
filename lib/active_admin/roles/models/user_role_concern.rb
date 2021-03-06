# Include this module into the Active Record model
# that stores the assigned roles.
module ActiveAdmin::UserRoleConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :user, :polymorphic => true
    belongs_to :role, :class_name => role_class_name

    validates_uniqueness_of :role_id,
        :scope => [:user_id, :user_type],
        :message => "has already been applied to this user"

    def self.set_roles(user, roles)
      transaction do
        where(:user_id => user.id, :user_type => user.class).delete_all

        roles.each do |role|
          create! do |ur|
            ur.user = user
            ur.role = role
          end
        end
      end
    end

    def self.find_roles(user)
      where(:user_id => user.id, :user_type => user.class).
        includes(:role).
        map(&:role)
    end

    def self.find_users(role)
      where(:role_id => role.id)
        includes(:user).
        map(&:user)
    end
  end
end

class ActiveAdmin::UserRole < ActiveRecord::Base
  self.table_name = "active_admin_user_roles"

  belongs_to :user, :polymorphic => true
  belongs_to :role

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

end

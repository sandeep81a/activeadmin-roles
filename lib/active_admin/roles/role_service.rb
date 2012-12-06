module ActiveAdmin

  class RoleService

    def initialize(roles_repo = ActiveAdmin::UserRole)
      @roles_repo = roles_repo
    end

    def set_roles(user, roles)
      @roles_repo.set_roles(user, roles)
    end

    def get_roles(user)
      @roles_repo.find_roles(user)
    end

    def get_users(role)
      @roles_repo.find_users(role)
    end

    def get_permissions(user)
      roles = get_roles(user)
      permissions = roles.map(&:permissions)

      permissions.flatten.uniq
    end

  end

end

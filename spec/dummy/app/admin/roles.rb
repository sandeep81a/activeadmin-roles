ActiveAdmin.register ActiveAdmin::Role, :as => "Role" do
  include ActiveAdmin::Roles

  menu parent: "Manage Users"

end

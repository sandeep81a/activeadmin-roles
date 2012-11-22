ActiveAdmin.register ActiveAdmin::Role, :as => "Role" do
  include ActiveAdmin::Roles::UI

  menu parent: "Manage Users"
end

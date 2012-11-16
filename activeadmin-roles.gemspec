$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/roles/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin-roles"
  s.version     = ActiveAdmin::Roles::VERSION
  s.authors     = ["REVERB"]
  s.email       = ["info@reverbhq.com"]
  s.homepage    = "reverbhq.com"
  s.summary     = "A roles and permission system for Active Admin"
  s.description = "A roles and permission system for Active Admin"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]

  s.add_dependency "activeadmin", ">= 0.4.2"
end

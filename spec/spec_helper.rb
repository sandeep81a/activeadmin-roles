# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'factory_girl'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
RAILS_ROOT = File.join(File.dirname(__FILE__), "dummy")

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |c|
  c.use_transactional_fixtures = true
  c.use_instantiated_fixtures = false
end


require 'pry'
require 'rspec'

require_relative 'support/database_cleaner'
require_relative '../app.rb'

require 'rack/test'
require 'shoulda/matchers'
require 'factory_bot'
require 'validate_url/rspec_matcher'

set :environment, :test
set :database, :test

ActiveRecord::Base.logger.level = 1

ENV['RACK_ENV'] = 'test'
ENV['BASE_URI'] = 'https://test.com'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  # Include Rack::Test::Methods
  config.include RSpecMixin

  # Include FactoryBot
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.backtrace_exclusion_patterns << /.rubies/
  config.backtrace_exclusion_patterns << /.gem/

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Keep as many of these lines as are necessary:
    with.library :active_record
    with.library :active_model
  end
end

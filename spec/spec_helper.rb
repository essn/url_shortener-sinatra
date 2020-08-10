require 'pry'
require 'rspec'

require_relative 'support/database_cleaner'
require_relative '../app.rb'

require 'rack/test'
require 'shoulda/matchers'

set :environment, :test
set :database, :test

ActiveRecord::Base.logger.level = 1

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.backtrace_exclusion_patterns << /.rubies/
  config.backtrace_exclusion_patterns << /.gem/

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed
end

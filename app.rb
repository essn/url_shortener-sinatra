require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'validate_url'

set :bind, '0.0.0.0' # bind to all interfaces

configure :development, :test do
  require 'pry'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

get '/' do
end

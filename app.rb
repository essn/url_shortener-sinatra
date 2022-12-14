require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/json'
require 'validate_url'
require 'interactor'

set :bind, '0.0.0.0' # bind to all interfaces
set :public_folder, File.dirname(__FILE__) + '/public'

configure :development do
  require 'pry'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].sort.each do |file|
  require file
  also_reload file
end

post '/short_url' do
  result = CreateShortUrl.call(slug: params[:slug],
                               original_url: params[:original_url])

  if result.success?
    short_url = ShortUrlDecorator.new(result.short_url)

    status 200
    json body: {
      message: 'Success! Be sure to keep your secret to delete your url later.',
      short_url: {
        shortened_url: short_url.shortened_url,
        secret_key: short_url.secret_key
      }
    }
  else
    status 422
    json body: { message: result.short_url.errors.full_messages }
  end
end

delete '/short_url/:slug' do
  unless params[:secret_key]
    halt 422, { message: 'secret_key parameter is required.' }.to_json
  end

  short_url = ShortUrl.find_by(slug: params[:slug])

  unless short_url
    halt 404, {
      message: "Short url '#{params[:slug]}' does not exist."
    }.to_json
  end

  if short_url.secret_key != params[:secret_key]
    halt 402, {
      message: 'You are not authorized to delete this short url.'
    }.to_json
  end

  short_url.delete
  status 204
end

get '/:slug' do
  stored_short_url = ShortUrl.find_by(slug: params[:slug])

  unless stored_short_url
    t = %w[text/css text/html application/javascript]

    # Redirect to generic 404 HTML page if not found
    return redirect '/404.html', 303 if request.preferred_type(t) == 'text/html'

    halt 404, message: "Short url #{params[:slug]} does not exist."
  end

  short_url = ShortUrlDecorator.new(stored_short_url)

  status 200
  json body: {
    short_url: {
      shortened_url: short_url.shortened_url,
      original_url: short_url.original_url,
      slug: short_url.slug
    }
  }
end

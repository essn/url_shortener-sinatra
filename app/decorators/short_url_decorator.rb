class ShortUrlDecorator
  def initialize(short_url)
    @short_url = short_url
  end

  def shortened_url
    "#{ENV['BASE_URI']}/#{short_url.slug}"
  end

  private

  def method_missing(method, *args)
    if short_url.respond_to?(method)
      short_url.send(method, *args)
    else
      super
    end
  end

  def respond_to?(*args)
    super
  end

  def respond_to_missing?(*args)
    true
  end
  
  attr_reader :short_url
end

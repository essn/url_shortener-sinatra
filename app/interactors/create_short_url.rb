class CreateShortUrl
  include Interactor

  def call
    secret_key = SecureRandom.uuid

    while ShortUrl.find_by(secret_key: secret_key)
      secret_key = SecureRandom.uuid
    end

    if context.slug
      context.short_url = ShortUrl.new(slug: context.slug,
                                       secret_key: context.secret_key,
                                       original_url: context.original_url)
    else
      slug = SecureRandom.alphanumeric(6)

      slug = SecureRandom.alphanumeric(6) while ShortUrl.find_by(slug: slug)

      context.short_url = ShortUrl.new(slug: slug,
                                       secret_key: secret_key,
                                       original_url: context.original_url)
    end

    if context.short_url.valid?
      context.short_url.save
    else
      context.fail!
    end
  end
end

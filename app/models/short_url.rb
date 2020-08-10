class ShortUrl < ActiveRecord::Base
  validates :original_url, presence: true, url: true
  validates :short_url, presence: true, uniqueness: true, url: true
  validates :secret_key, presence: true, uniqueness: true
end

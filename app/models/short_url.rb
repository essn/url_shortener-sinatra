class ShortUrl < ActiveRecord::Base
  validates :original_url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true
  validates :secret_key, presence: true, uniqueness: true
end

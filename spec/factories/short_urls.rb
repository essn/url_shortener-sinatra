FactoryBot.define do
  factory :short_url do
    sequence(:original_url) { |n| "https://url.com#{n}" }
    sequence(:short_url) { |n| "https://shorturl.com#{n}" }
    sequence(:secret_key) { |n| "secretkey#{n}" }
  end
end

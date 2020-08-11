FactoryBot.define do
  factory :short_url do
    sequence(:original_url) { |n| "https://url.com#{n}" }
    sequence(:slug) { |n| "slug#{n}" }
    sequence(:secret_key) { |n| "secretkey#{n}" }
  end
end

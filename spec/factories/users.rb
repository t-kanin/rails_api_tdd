FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "John#{n}" }
    name { "John" }
    url { "www.example.com" }
    avatar_url { "www.example.com/avatar" }
    provider { "github" }
  end
end

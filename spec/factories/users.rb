FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name 'test'
    last_name 'user'
    sequence(:email) { |n| "test#{n}@gmail.com" }
    password 'password'
  end
end

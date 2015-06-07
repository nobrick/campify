FactoryGirl.define do
  factory :user do
    sequence(:username, 100) { |n| "user#{n}" }
    password 'abcdefg'
    sequence(:email, 100) { |n| "user#{n}@mingqu.me" }
    admin false
    coins 0
    bio ''
    university
  end
end

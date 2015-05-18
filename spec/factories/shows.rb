FactoryGirl.define do
  factory :show do
    name 'name'
    category 'category'
    description 'description text'
    association :proposer, factory: :user
  end
end

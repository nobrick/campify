FactoryGirl.define do
  factory :campus_vote do
    user
    university
    association :ballot, factory: :campus_ballot
    vote_for_own_uni false
  end
end

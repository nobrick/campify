FactoryGirl.define do
  factory :lottery do
    user
    lottery_event
    hit false
    hits_at nil
  end
end

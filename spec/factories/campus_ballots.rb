FactoryGirl.define do
  factory :campus_ballot do
    showtime
    expires_at 3.days.since
    expired false
  end
end

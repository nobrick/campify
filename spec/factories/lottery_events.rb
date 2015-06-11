FactoryGirl.define do
  factory :lottery_event do
    showtime
    draws_at 3.days.since
    lottery_rule "enrollment"
    prizes_num 1
    prize_type 'normal'
  end
end

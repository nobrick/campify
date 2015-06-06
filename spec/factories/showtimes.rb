FactoryGirl.define do
  factory :showtime do
    show
    title 'title'
    description 'description'
    starts_at '2015-05-20 20:00:00'
    ends_at '2015-05-21 20:00:00'
    ongoing true
    enrollable true
  end
end

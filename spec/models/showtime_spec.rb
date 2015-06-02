require 'rails_helper'

RSpec.describe Showtime, type: :model do
  let(:showtime) { create :showtime }
  let(:user) { create :user }

  it 'creates showtime model' do
    expect(showtime).to be_persisted
  end

  it 'sets ongoing to true by default' do
    expect(Showtime.new.ongoing).to eq true
  end

  it 'fails validation if ends_at < starts_at' do
    showtime = build :showtime, starts_at: Time.now, ends_at: Time.now - 1.day
    expect(showtime).not_to be_valid
  end

  it 'associates members' do
    create :enrollment, showtime_id: showtime.id, user_id: user.id
    expect(showtime.members).to eq [ user ]
  end

  it 'has one ballot' do
    ballot = create :campus_ballot, showtime_id: showtime.id
    expect(showtime.ballot).to eq ballot
  end

  describe '.ongoing' do
    it 'lists ongoing showtimes' do
      showtime_ongoing = create :showtime, ongoing: true
      showtime_accomplished = create :showtime, ongoing: false
      expect(Showtime.ongoing).to eq [ showtime_ongoing ]
    end
  end

  describe '.enrolled_by(user)' do
    let(:another_user) { create :user }
    let(:showtimes) { 3.times.collect { create :showtime } }

    it 'lists showtimes enrolled by the user ordered by enrollment time' do
      enrollments = [
        create(:enrollment, user_id: user.id, showtime_id: showtimes[0].id),
        create(:enrollment, user_id: user.id, showtime_id: showtimes[1].id),
        create(:enrollment, user_id: another_user.id, showtime_id: showtimes[2].id)
      ]
      expect(Showtime.enrolled_by(another_user)).to eq [ showtimes[2] ]
      expect(Showtime.enrolled_by(user)).to eq [ showtimes[1], showtimes[0] ]
    end
  end
end

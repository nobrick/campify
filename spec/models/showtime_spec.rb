require 'rails_helper'

RSpec.describe Showtime, type: :model do
  let(:showtime) { create :showtime }
  let(:showtime_enrollable) { create :showtime, enrollable: true }
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

  it 'associates enrollees' do
    create :enrollment, showtime_id: showtime_enrollable.id, user_id: user.id
    expect(showtime_enrollable.enrollees).to eq [ user ]
  end

  describe 'associated ballot' do
    let!(:ballot) { create :campus_ballot, showtime_id: showtime.id }

    it 'has one ballot' do
      expect(showtime.ballot).to eq ballot
    end

    it 'destorys dependent models when showtime destroyed' do
      expect { showtime.destroy }.to change(CampusBallot, :count).by -1
    end
  end

  describe '.ongoing' do
    it 'lists ongoing showtimes' do
      showtime_ongoing = create :showtime, ongoing: true
      showtime_accomplished = create :showtime, ongoing: false
      expect(Showtime.ongoing).to eq [ showtime_ongoing ]
    end
  end

  describe '.enrollable' do
    it 'lists enrollable showtimes' do
      showtime_1 = create :showtime, enrollable: true
      showtime_2 = create :showtime, enrollable: false
      showtime_3 = create :showtime, enrollable: true
      expect(Showtime.enrollable).to eq [ showtime_3, showtime_1 ]
    end
  end

  describe '.on_ballot' do
    it 'lists showtimes on ballot' do
      showtime_1 = create :showtime
      showtime_2 = create :showtime
      showtime_3 = create :showtime
      create :campus_ballot, showtime_id: showtime_3.id
      create :campus_ballot, showtime_id: showtime_1.id
      expect(Showtime.on_ballot).to eq [ showtime_3, showtime_1 ]
    end
  end

  describe '.enrolled_by(user)' do
    let(:another_user) { create :user }
    let(:showtimes) { 3.times.collect { create :showtime, enrollable: true } }

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

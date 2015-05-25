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
end

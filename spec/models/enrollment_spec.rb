require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:user) { create :user }
  let(:showtime) { create :showtime }
  let(:enrollment_params) { { user_id: user.id, showtime_id: showtime.id } }
  let!(:enrollment) { create :enrollment, enrollment_params }
  it 'creates enrollment model' do
    expect(enrollment).to be_persisted
  end

  it 'fails to create enrollment with same [ user, showtime ]' do
    expect { create :enrollment, enrollment_params }
      .to raise_error ActiveRecord::RecordInvalid
  end
end

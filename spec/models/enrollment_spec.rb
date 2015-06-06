require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:user) { create :user }
  let(:showtime) { create :showtime, enrollable: true }
  let(:non_enrollable) { create :showtime, enrollable: false }
  let(:enrollment_params) { { user_id: user.id, showtime_id: showtime.id } }
  let(:enrollment) { create :enrollment, enrollment_params }

  it 'creates enrollment model' do
    enrollment
    expect(enrollment).to be_persisted
  end

  it 'fails to create enrollment with same [ user, showtime ]' do
    enrollment
    expect { create :enrollment, enrollment_params }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it 'fails to create enrollment with non-enrollable showtime' do
    params = { user_id: user.id, showtime_id: non_enrollable.id }
    expect { create :enrollment, params }
      .to raise_error ActiveRecord::RecordInvalid
  end
end

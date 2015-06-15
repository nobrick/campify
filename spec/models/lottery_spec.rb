require 'rails_helper'

RSpec.describe Lottery, type: :model do
  let(:user) { create :user }
  let(:lottery_event) { create :lottery_event }
  let(:lottery_attrs) { { lottery_event_id: lottery_event.id, user_id: user.id } }
  let(:lottery) { create :lottery, lottery_attrs }

  it 'creates lottery model' do
    expect(lottery).to be_persisted
  end

  it 'fails to create lottery for already drawn lottery event' do
    lottery_event.update_attribute :drawn, true
    expect { create :lottery, lottery_event: lottery_event }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it 'fails to create lottery with same user and lottery_event' do
    lottery
    expect { create :lottery, lottery_attrs }
      .to raise_error ActiveRecord::RecordInvalid
  end
end

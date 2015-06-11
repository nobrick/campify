require 'rails_helper'

RSpec.describe LotteryEvent, type: :model do
  let(:lottery_event) { create :lottery_event }

  it 'creates lottery event model' do
    expect(lottery_event).to be_persisted
  end

  describe '#lottery_rule' do
    it 'must be in the list' do
      expect { create :lottery_event, lottery_rule: 'NONE' }
        .to raise_error ActiveRecord::RecordInvalid
    end

    context 'when rule equals to ballot' do
      let(:invalid_showtime) { create :showtime, ballot: nil }

      it 'must be after creation of showtime ballot' do
        expect { create :lottery_event, lottery_rule: 'ballot', showtime_id: invalid_showtime.id }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'when rule equals to enrollment' do
      let(:invalid_showtime) { create :showtime, enrollable: false }

      it 'must be after showtime enrollable turned on' do
        expect { create :lottery_event, lottery_rule: 'enrollment', showtime_id: invalid_showtime.id }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

  end
end

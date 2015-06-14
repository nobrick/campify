require 'rails_helper'

RSpec.describe LotteryEvent, type: :model do
  let(:showtime) { create :showtime, enrollable: true }
  let(:lottery_event) { create :lottery_event, showtime_id: showtime.id }

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

      it 'must be after creating showtime ballot' do
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

  describe '#drawn' do
    it 'cannot save if drawn' do
      lottery_event.update_attribute(:drawn, true)
      expect(lottery_event.reload.valid?).to be_falsy
    end
  end

  describe 'draw' do
    let(:users) { create_list :user, 20 }
    let(:prizes_num) { 5 }

    shared_examples_for :draw_success do
      it 'draws lotteries for lucky users' do
        expect(lottery_event.draw).to eq true
        winners = lottery_event.winners
        expect(lottery_event.last_failure_code.value).to be_blank
        expect(winners.count).to eq prizes_num
        expect(candidates & winners).to eq winners
      end
    end

    context 'when lottery rule is on enrollment' do
      let(:l_attrs) { { showtime_id: showtime.id,
                        lottery_rule: 'enrollment',
                        prizes_num: prizes_num } }
      let(:lottery_event) { create :lottery_event, l_attrs }
      let(:candidates) { users[0..9] }
      before do
        users[0..9].each do |user|
          create :enrollment, showtime_id: showtime.id, user_id: user.id
        end
      end
      it_behaves_like :draw_success
    end

    context 'when lottery rule is on ballot' do
      let(:unis) { create_pair(:university) }
      let(:l_attrs) { { showtime_id: showtime.id,
                        lottery_rule: 'ballot',
                        prizes_num: prizes_num } }
      let(:lottery_event) { create :lottery_event, l_attrs }

      context 'under normal conditions' do
        before { set_ballot_and_votes(user_fixtures) }
        let(:candidates) { users[0..7] }
        let(:user_fixtures) do
          [ {
            users: users[0..7],
            uni_belongs_to: unis[0],
            uni_votes_for: unis[0]
          }, {
            users:  users[8..11],
            uni_belongs_to: unis[1],
            uni_votes_for: unis[0]
          }, {
            users: users[12..19],
            uni_belongs_to: unis[1],
            uni_votes_for: unis[1]
          } ]
        end
        it_behaves_like :draw_success
      end

      context 'when exists multiple most voted unis' do
        before { set_ballot_and_votes(fixtures_multi_most_voted) }
        let(:fixtures_multi_most_voted) do
          [ {
            users: users[0..7],
            uni_belongs_to: unis[0],
            uni_votes_for: unis[0]
          }, {
            users:  users[2..9],
            uni_belongs_to: unis[1],
            uni_votes_for: unis[0]
          }, {
            users: users[10..19],
            uni_belongs_to: unis[1],
            uni_votes_for: unis[1]
          } ]
        end

        it 'does not draw and sets last_failure_code' do
          lottery_event.draw
          expect(lottery_event.draw).to eq false
          expect(lottery_event.last_failure_code.value).to eq 'multi_most_voted_universities'
        end
      end

      def set_ballot_and_votes(user_fixtures)
        create :campus_ballot, showtime_id: showtime.id
        user_fixtures.each do |s|
          s[:users].each do |user|
            user.update_attribute(:university_id, s[:uni_belongs_to].id)
            user.vote_for(showtime, s[:uni_votes_for])
          end
        end
      end

    end
  end
end

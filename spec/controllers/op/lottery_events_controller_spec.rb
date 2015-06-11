require 'rails_helper'

RSpec.describe Op::LotteryEventsController, type: :controller do
  let(:showtime) { create :showtime }
  let(:lottery_event) { create :lottery_event, showtime_id: showtime.id }
  let(:valid_attributes) { { draws_at: 3.days.since,
                             lottery_rule: 'enrollment',
                             prizes_num: 10 } }
  let(:invalid_attributes) { valid_attributes.merge(lottery_rule: 'NONE') }
  let(:valid_params) { { showtime_id: showtime.id, lottery_event: valid_attributes } }
  let(:invalid_params) { { showtime_id: showtime.id, lottery_event: invalid_attributes } }

  context 'Admin signed in' do
    let(:admin) { create :user, admin: true }
    before { sign_in admin }

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new LotteryEvent' do
          expect { post :create, valid_params }
            .to change(LotteryEvent, :count).by 1
        end

        it 'assigns a newly created lottery_event as @lottery_event' do
          post :create, valid_params
          expect(assigns(:lottery_event)).to be_a LotteryEvent
          expect(assigns(:lottery_event)).to be_persisted
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved lottery_event as @lottery_event' do
          post :create, invalid_params
          expect(assigns(:lottery_event)).to be_a_new LotteryEvent
        end
      end
    end

    describe 'PUT #update' do
      before { lottery_event }
      let(:new_date) { 99.days.since }
      let(:new_params) { valid_params.merge(lottery_event: { draws_at: new_date }) }

      context 'with valid params' do
        it 'updates the requested lottery_event' do
          put :update, new_params
          lottery_event.reload
          expect(lottery_event.draws_at.to_s).to eq new_date.to_s
        end

        it 'assigns the requested lottery_event as @lottery_event' do
          put :update, new_params
          expect(assigns(:lottery_event)).to eq lottery_event
        end
      end

      context 'with invalid params' do
        it 'assigns the lottery_event as @lottery_event' do
          put :update, invalid_params
          expect(assigns(:lottery_event)).to eq lottery_event
        end
      end
    end

    describe 'DELETE #destroy' do
      before { lottery_event }

      it 'destroys the requested lottery_event' do
        expect { delete :destroy, valid_params }
          .to change(LotteryEvent, :count).by -1
      end
    end
  end

end

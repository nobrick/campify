require 'rails_helper'

RSpec.describe Op::CampusBallotsController, type: :controller do
  let(:showtime) { create :showtime }
  let(:ballot) { create :campus_ballot, showtime_id: showtime.id }
  let(:valid_attributes) { { expires_at: 3.days.since } }
  let(:invalid_attributes) { { expires_at: 1.days.ago } }
  let(:valid_params) { { showtime_id: showtime.id, ballot: valid_attributes } }
  let(:invalid_params) { { showtime_id: showtime.id, ballot: invalid_attributes } }

  context 'Admin signed in' do
    let(:admin) { create :user, admin: true }
    before { sign_in admin }

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new CampusBallot' do
          expect { post :create, valid_params }
            .to change(CampusBallot, :count).by 1
        end

        it 'assigns a newly created ballot as @ballot' do
          post :create, valid_params
          expect(assigns(:ballot)).to be_a CampusBallot
          expect(assigns(:ballot)).to be_persisted
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved ballot as @ballot' do
          post :create, invalid_params
          expect(assigns(:ballot)).to be_a_new CampusBallot
        end
      end
    end

    describe 'PUT #update' do
      before { ballot }
      let(:new_date) { 99.days.since }
      let(:new_params) { valid_params.merge(ballot: { expires_at: new_date }) }

      context 'with valid params' do
        it 'updates the requested ballot' do
          put :update, new_params
          ballot.reload
          expect(ballot.expires_at.to_s).to eq new_date.to_s
        end

        it 'assigns the requested ballot as @ballot' do
          put :update, new_params
          expect(assigns(:ballot)).to eq ballot
        end
      end

      context 'with invalid params' do
        it 'assigns the ballot as @ballot' do
          put :update, invalid_params
          expect(assigns(:ballot)).to eq ballot
        end
      end
    end

    describe 'DELETE #destroy' do
      before { ballot }

      it 'destroys the requested ballot' do
        expect { delete :destroy, valid_params }
          .to change(CampusBallot, :count).by -1
      end
    end
  end

end

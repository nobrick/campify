require 'rails_helper'

RSpec.describe Uni::EnrollmentsController, type: :controller do
  let(:user) { create :user }
  let(:showtime) { create :showtime, enrollable: true }
  let(:valid_attributes) { { showtime_id: showtime.id } }
  context 'User not signed in' do
    describe 'Actions' do
      it 'redirects to sign-in page' do
        post :create, { enrollment: valid_attributes }
        expect(response).to redirect_to new_uni_user_session_url
      end
    end
  end

  context 'User signed in' do
    before { sign_in user }
    describe 'POST #create' do
      it 'creates showtime enrollment' do
        expect { post :create, { enrollment: valid_attributes } }
          .to change(Enrollment, :count).by 1
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys showtime enrollment' do
        valid_enrollment = create :enrollment, user_id: user.id
        expect { delete :destroy, id: valid_enrollment.to_param }
          .to change(Enrollment, :count).by -1
      end

      it 'only destroys enrollment that belongs to current user' do
        invalid_enrollment = create :enrollment
        expect { delete :destroy, id: invalid_enrollment.to_param }
          .not_to change(Enrollment, :count)
      end
    end
  end
end

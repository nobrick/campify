require 'rails_helper'

RSpec.describe Op::ShowtimesController, type: :controller do
  let!(:showtime) { create :showtime }
  let(:show) { create :show }
  let(:valid_attributes) { attributes_for(:showtime).merge(show_id: show.id) }
  let(:invalid_attributes) { valid_attributes.merge(show_id: 404) }

  context 'Admin signed in' do
    let(:admin) { create :user, admin: true }
    before { sign_in admin }

    describe 'GET #index' do
      it 'assigns all showtimes as @showtimes' do
        get :index
        expect(assigns(:showtimes)).to eq [ showtime ]
      end
    end

    describe 'GET #show' do
      it 'assigns the requested showtime as @showtime' do
        get :show, { id: showtime.to_param }
        expect(assigns(:showtime)).to eq showtime
      end
    end

    describe 'GET #new' do
      it 'assigns a new showtime as @showtime' do
        get :new
        expect(assigns(:showtime)).to be_a_new Showtime
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested showtime as @showtime' do
        get :edit, { id: showtime.to_param }
        expect(assigns(:showtime)).to eq showtime
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Showtime' do
          expect { post :create, { showtime: valid_attributes } }
            .to change(Showtime, :count).by 1
        end

        it 'assigns a newly created showtime as @showtime' do
          post :create, { showtime: valid_attributes }
          expect(assigns(:showtime)).to be_a Showtime
          expect(assigns(:showtime)).to be_persisted
        end

        it 'redirects to the created showtime' do
          post :create, { showtime: valid_attributes }
          expect(response).to redirect_to op_showtime_url(Showtime.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved showtime as @showtime' do
          post :create, { showtime: invalid_attributes }
          expect(assigns(:showtime)).to be_a_new Showtime
        end

        it 're-renders the :new template' do
          post :create, { :showtime => invalid_attributes }
          expect(response).to render_template 'new'
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        it 'updates the requested showtime' do
          put :update, { id: showtime.to_param, showtime: { title: 'new_name' } }
          showtime.reload
          expect(showtime.title).to eq 'new_name'
        end

        it 'assigns the requested showtime as @showtime' do
          put :update, { id: showtime.to_param, showtime: valid_attributes }
          expect(assigns(:showtime)).to eq showtime
        end

        it 'redirects to the showtime' do
          put :update, { id: showtime.to_param, showtime: valid_attributes }
          expect(response).to redirect_to op_showtime_url(showtime)
        end
      end

      context 'with invalid params' do
        it 'assigns the showtime as @showtime' do
          put :update, { id: showtime.to_param, showtime: invalid_attributes}
          expect(assigns(:showtime)).to eq showtime
        end

        it 're-renders the :edit template' do
          put :update, { id: showtime.to_param, showtime: invalid_attributes}
          expect(response).to render_template 'edit'
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested showtime' do
        expect { delete :destroy, {:id => showtime.to_param} }
          .to change(Showtime, :count).by -1
      end

      it 'redirects to the showtimes list' do
        delete :destroy, { id: showtime.to_param }
        expect(response).to redirect_to op_showtimes_url
      end
    end
  end

end

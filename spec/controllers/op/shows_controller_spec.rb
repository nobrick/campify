require 'rails_helper'

RSpec.describe Op::ShowsController, type: :controller do
  let!(:show) { create :show }
  let(:valid_attributes) { attributes_for(:show) }
  let(:invalid_attributes) { valid_attributes.merge(name: '') }

  context 'Admin not signed in' do
    shared_examples 'admin authentication failure' do
      it 'fails for :index, :new, :show and :edit' do
        id_param = { id: show.to_param }
        params = { show: id_param, edit: id_param }
        [ :index, :new, :show, :edit ].each do |method|
          get method, params.fetch(method, {})
          expect(response).to redirect_to home_index_path
        end
      end

      it 'fails for :create' do
        expect { post :create, { show: valid_attributes } }
          .not_to change(Show, :count)
      end

      it 'fails to :update' do
        put :update, { id: show.to_param, show: { name: 'new_name' } }
        show.reload
        expect(show.name).not_to eq 'new_name'
      end
    end

    describe 'Authentication with user but admin signed in' do
      let(:normal_user) { create :user, admin: false }
      before { sign_in normal_user }
      it_behaves_like 'admin authentication failure'
    end

    describe 'Authentication with no user signed in' do
      it_behaves_like 'admin authentication failure'
    end
  end

  context 'Admin signed in' do
    let(:proposer) { create :user, admin: true }
    before { sign_in proposer }

    describe 'GET #index' do
      it 'assigns all shows as @shows' do
        get :index
        expect(assigns(:shows)).to eq [ show ]
      end
    end

    describe 'GET #show' do
      it 'assigns the requested show as @show' do
        get :show, { id: show.to_param }
        expect(assigns(:show)).to eq show
      end
    end

    describe 'GET #new' do
      it 'assigns a new show as @show' do
        get :new
        expect(assigns(:show)).to be_a_new Show
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested show as @show' do
        get :edit, { id: show.to_param }
        expect(assigns(:show)).to eq show
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Show' do
          expect { post :create, { show: valid_attributes } }
            .to change(Show, :count).by 1
        end

        it 'assigns a newly created show as @show' do
          post :create, { show: valid_attributes }
          expect(assigns(:show)).to be_a Show
          expect(assigns(:show)).to be_persisted
        end

        it 'redirects to the created show' do
          post :create, { show: valid_attributes }
          expect(response).to redirect_to op_show_url(Show.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved show as @show' do
          post :create, { show: invalid_attributes }
          expect(assigns(:show)).to be_a_new Show
        end

        it 're-renders the :new template' do
          post :create, { :show => invalid_attributes }
          expect(response).to render_template 'new'
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        it 'updates the requested show' do
          put :update, { id: show.to_param, show: { name: 'new_name' } }
          show.reload
          expect(show.name).to eq 'new_name'
        end

        it 'assigns the requested show as @show' do
          put :update, { id: show.to_param, show: valid_attributes }
          expect(assigns(:show)).to eq show
        end

        it 'redirects to the show' do
          put :update, { id: show.to_param, show: valid_attributes }
          expect(response).to redirect_to op_show_url(show)
        end
      end

      context 'with invalid params' do
        it 'assigns the show as @show' do
          put :update, { id: show.to_param, show: invalid_attributes}
          expect(assigns(:show)).to eq show
        end

        it 're-renders the :edit template' do
          put :update, { id: show.to_param, show: invalid_attributes}
          expect(response).to render_template 'edit'
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested show' do
        expect { delete :destroy, {:id => show.to_param} }
          .to change(Show, :count).by -1
      end

      it 'redirects to the shows list' do
        delete :destroy, { id: show.to_param }
        expect(response).to redirect_to op_shows_url
      end
    end
  end

end

require 'rails_helper'

RSpec.describe Op::UniversitiesController, type: :controller do
  let!(:university) { create :university }
  let(:valid_attributes) { attributes_for(:university) }
  let(:invalid_attributes) { valid_attributes.merge(name: '') }

  context 'Admin signed in' do
    let(:user) { create :user, admin: true }
    before { sign_in user }

    describe 'GET #index' do
      it 'assigns all universities as @universities' do
        get :index
        expect(assigns(:universities)).to eq [ university ]
      end
    end

    describe 'GET #show' do
      it 'assigns the requested university as @university' do
        get :show, { id: university.to_param }
        expect(assigns(:university)).to eq university
      end
    end

    describe 'GET #new' do
      it 'assigns a new university as @university' do
        get :new
        expect(assigns(:university)).to be_a_new University
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested university as @university' do
        get :edit, { id: university.to_param }
        expect(assigns(:university)).to eq university
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new University' do
          expect { post :create, { university: valid_attributes } }
            .to change(University, :count).by 1
        end

        it 'assigns a newly created university as @university' do
          post :create, { university: valid_attributes }
          expect(assigns(:university)).to be_a University
          expect(assigns(:university)).to be_persisted
        end

        it 'redirects to the created university' do
          post :create, { university: valid_attributes }
          expect(response).to redirect_to [ :op, University.last ]
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved university as @university' do
          post :create, { university: invalid_attributes }
          expect(assigns(:university)).to be_a_new University
        end

        it 're-renders the :new template' do
          post :create, { :university => invalid_attributes }
          expect(response).to render_template 'new'
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        it 'updates the requested university' do
          put :update, { id: university.to_param, university: { name: 'new_name' } }
          university.reload
          expect(university.name).to eq 'new_name'
        end

        it 'assigns the requested university as @university' do
          put :update, { id: university.to_param, university: valid_attributes }
          expect(assigns(:university)).to eq university
        end

        it 'redirects to the university' do
          put :update, { id: university.to_param, university: valid_attributes }
          expect(response).to redirect_to [ :op, university ]
        end
      end

      context 'with invalid params' do
        it 'assigns the university as @university' do
          put :update, { id: university.to_param, university: invalid_attributes}
          expect(assigns(:university)).to eq university
        end

        it 're-renders the :edit template' do
          put :update, { id: university.to_param, university: invalid_attributes}
          expect(response).to render_template 'edit'
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested university' do
        expect { delete :destroy, {:id => university.to_param} }
          .to change(University, :count).by -1
      end

      it 'redirects to the university list' do
        delete :destroy, { id: university.to_param }
        expect(response).to redirect_to op_universities_url
      end
    end
  end

end

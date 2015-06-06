require 'rails_helper'

RSpec.describe Uni::CampusVotesController, type: :controller do
  before { sign_in (create :user) }
  let(:showtime) { create :showtime }
  let(:university) { create :university }
  let(:vote_attrs) { { university_id: university.id } }
  let(:vote_params) { { showtime_id: showtime.id, vote: vote_attrs } }

  describe 'POST #create' do
    context 'With ballot enabled' do
      before { create :campus_ballot, showtime_id: showtime.id }
      it 'creates a new vote' do
        expect { post :create, vote_params }.to change(CampusVote, :count).by 1
      end

      it 'cannot vote twice' do
        attrs_with_new_uni = { vote: { university_id: (create :university).id } }
        post :create, vote_params.merge(attrs_with_new_uni)
        expect { post :create, vote_params }.not_to change(CampusVote, :count)
        expect(response).to render_template 'uni/showtimes/show'
      end
    end

    context 'When ballot disabled' do
      it 'cannot create new vote' do
        expect { post :create, vote_params }.not_to change(CampusVote, :count)
        expect(response).to render_template 'uni/showtimes/show'
      end
    end
  end

end

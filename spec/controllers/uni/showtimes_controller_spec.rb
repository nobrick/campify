require 'rails_helper'

RSpec.describe Uni::ShowtimesController, type: :controller do
  let(:showtime) { create :showtime }

  describe 'GET #show' do
    it 'returns http success' do
      get :show, { id: showtime.to_param }
      expect(response).to have_http_status :success
    end
  end
end

require 'rails_helper'

RSpec.describe Uni::ProfileController, type: :controller do
  before { sign_in (create :user) }

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end
end

require 'rails_helper'

RSpec.describe "AccessTokens", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/access_token/create"
      expect(response).to have_http_status(:success)
    end
  end

end

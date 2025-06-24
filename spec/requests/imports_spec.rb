require 'rails_helper'

RSpec.describe "Imports", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/imports/index"
      expect(response).to have_http_status(:success)
    end
  end

end

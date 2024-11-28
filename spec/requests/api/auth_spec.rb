require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /auth/login" do
    it "returns http success" do
      post "/auth/login", params: { email: "openclade@gmail.com", password: "password" }
      expect(response).to have_http_status(:success)
    end
  end
  
end

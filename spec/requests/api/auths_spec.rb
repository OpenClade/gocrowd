require 'swagger_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /auth/login" do
    let(:user) { create(:user, email: "openclade@gmail.com", password: "password") }

    it "returns http success with valid credentials" do
      post "/auth/login", params: { auth: { email: user.email, password: "password" } }
      expect(response).to have_http_status(:accepted)
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "returns unauthorized with invalid credentials" do
      post "/auth/login", params: { auth: { email: user.email, password: "wrongpassword" } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["message"]).to eq("Incorrect password")
    end

    it "returns unauthorized if user does not exist" do
      post "/auth/login", params: { auth: { email: "nonexistent@example.com", password: "password" } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["message"]).to eq("User doesn't exist")
    end
  end
end
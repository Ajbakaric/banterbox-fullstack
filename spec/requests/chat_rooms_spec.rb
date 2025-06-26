require 'rails_helper'

RSpec.describe "ChatRooms API", type: :request do
  describe "GET /api/v1/chat_rooms" do
    before do
      3.times { create(:chat_room) }
    end

    it "returns chat rooms" do
      get "/api/v1/chat_rooms"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end

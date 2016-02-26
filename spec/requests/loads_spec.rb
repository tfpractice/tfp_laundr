require 'rails_helper'

RSpec.describe "Loads", type: :request do
  describe "GET /loads" do
    it "works! (now write some real specs)" do
      get loads_path
      expect(response).to have_http_status(200)
    end
  end
end

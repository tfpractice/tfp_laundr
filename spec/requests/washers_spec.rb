require 'rails_helper'

RSpec.describe "Washers", type: :request do
  describe "GET /washers" do
    it "works! (now write some real specs)" do
      get washers_path
      expect(response).to have_http_status(200)
    end
  end
end

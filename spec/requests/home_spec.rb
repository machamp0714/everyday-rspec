require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    it "works! (now write some real specs)" do
      get home_path
      expect(response).to have_http_status(200)
    end
  end
end

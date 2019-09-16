# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Letters", type: :request do
  let(:user) { create(:user, :system) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /letters" do
    it "renders the correct template" do
      get letters_path

      expect(response).to render_template("letters/index")
    end

    it "responds with a 200 status code" do
      get letters_path

      expect(response.code).to eq("200")
    end
  end
end

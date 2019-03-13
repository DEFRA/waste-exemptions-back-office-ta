# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "/" do
    context "when a valid user is signed in" do
      before do
        sign_in(create(:user))
        # Stub the service to reduce database hits
        results = Kaminari.paginate_array([]).page(1)
        allow_any_instance_of(SearchService).to receive(:search).and_return(results)
      end

      it "renders the index template" do
        get "/"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/"
        expect(response).to have_http_status(200)
      end

      context "when there is a term, a filter and a page" do
        it "calls a SearchService with the correct params" do
          expect_any_instance_of(SearchService).to receive(:search).with("foo", :registrations, "2")
          get "/", term: "foo", filter: "registrations", page: "2"
        end
      end

      context "when the SearchService does not return results" do
        it "says there are no results" do
          get "/", term: "foo"
          expect(response.body).to include("No results")
        end
      end

      context "when the SearchService returns results" do
        let(:registration) { create(:registration) }

        before do
          results = Kaminari.paginate_array([registration]).page(1)
          allow_any_instance_of(SearchService).to receive(:search).and_return(results)
        end

        it "lists the results" do
          get "/", term: "foo"
          expect(response.body).to include(registration.reference)
        end
      end
    end

    context "when a deactivated user is signed in" do
      before { sign_in(create(:user, :inactive)) }

      it "redirects to the deactivated page" do
        get "/"
        expect(response).to redirect_to("/pages/deactivated")
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

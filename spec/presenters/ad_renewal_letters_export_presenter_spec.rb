# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdRenewalLettersExportPresenter do
  let(:ad_renewal_letters_export) { create(:ad_renewal_letters_export) }
  subject(:presenter) { described_class.new(ad_renewal_letters_export) }

  describe "#downloadable?" do
    before do
      ad_renewal_letters_export.status = status
    end

    context "when the export succeded" do
      let(:status) { :succeded }

      before do
        ad_renewal_letters_export.number_of_letters = number_of_letters
      end

      context "when the number of letters is more than zero" do
        let(:number_of_letters) { 1 }

        it "returns true" do
          expect(presenter).to be_downloadable
        end
      end

      context "when the number of letters is 0" do
        let(:number_of_letters) { 0 }

        it "returns false" do
          expect(presenter).to_not be_downloadable
        end
      end
    end

    context "when the export failed" do
      let(:status) { :failed }

      it "return false" do
        expect(presenter).to_not be_downloadable
      end
    end
  end

  describe "#print_label" do
    before do
      ad_renewal_letters_export.status = status
    end

    context "when the export failed" do
      let(:status) { :failed }

      it "returns nil" do
        expect(presenter.print_label).to be_nil
      end
    end

    context "when the export succeded" do
      let(:status) { :succeded }

      context "when the export has been printed" do
        it "returns a label with the printed status" do
          ad_renewal_letters_export.printed_by = "katherine.johnson@nasa.org.uk"
          ad_renewal_letters_export.printed_on = Date.today

          expect(presenter.print_label).to include("Katherine Johnson")
        end
      end
    end
  end
end

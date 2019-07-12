# frozen_string_literal: true

require "rails_helper"

module BoxyExport
  RSpec.describe GeneratorService do
    describe ".run" do
      it "generates a zip file containing data for BOXY and load it to AWS" do
        described_class.run
        # expect(described_class.run)
      end
    end
  end
end

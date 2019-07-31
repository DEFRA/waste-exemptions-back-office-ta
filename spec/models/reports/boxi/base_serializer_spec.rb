# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe BaseSerializer do
      describe "#file_name" do
        it "raises a not implemented error" do
          expect { subject.file_name }.to raise_error(NotImplementedError)
        end
      end

      describe "#records_scope" do
        it "raises a not implemented error" do
          expect { subject.records_scope }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end

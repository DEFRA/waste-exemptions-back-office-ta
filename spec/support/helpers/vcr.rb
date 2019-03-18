# frozen_string_literal: true

module Helpers
  module VCR
    def self.export_matcher(bucket)
      lambda do |request_a, request_b|
        [
          request_a.uri.include?(bucket),
          request_b.uri.include?(bucket),
          request_a.uri.split("/").last == request_b.uri.split("/").last,
          request_a.uri.split(".").last == "csv",
          request_b.uri.split(".").last == "csv"
        ].all?
      end
    end
  end
end

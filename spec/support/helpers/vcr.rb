# frozen_string_literal: true

module Helpers
  module VCR
    def self.export_matcher(bucket)
      lambda do |request_1, request_2|
        [
          request_1.uri.include?(bucket),
          request_2.uri.include?(bucket),
          request_1.uri.split('/').last == request_2.uri.split('/').last,
          request_1.uri.split('.').last == "csv",
          request_2.uri.split('.').last == "csv",
        ].all?
      end
    end
  end
end

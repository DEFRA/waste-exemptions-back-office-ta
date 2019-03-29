# frozen_string_literal: true

module Helpers
  module VCR
    def self.save_export_matcher(bucket, file_name_base)
      lambda do |request_a, request_b|
        [
          request_a.uri.include?(bucket),
          request_b.uri.include?(bucket),
          request_a.uri.include?(file_name_base),
          request_b.uri.include?(file_name_base),
          request_a.uri.split(".").last == "csv",
          request_b.uri.split(".").last == "csv"
        ].all?
      end
    end

    def self.export_bucket_matcher(bucket)
      lambda do |request_a, request_b|
        [
          request_a.uri.include?(bucket),
          request_b.uri.include?(bucket),
          !request_a.uri.include?("csv"),
          !request_b.uri.include?("csv")
        ].all?
      end
    end
  end
end

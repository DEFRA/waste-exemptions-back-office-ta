# frozen_string_literal: true

module DefraRuby
  module Exporters
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      ATTRIBUTES = %i[
        batch_size
        aws_region
        epr_export_aws_credentials
        epr_export_s3_bucket
        epr_export_filename
        bulk_export_aws_credentials
        bulk_export_s3_bucket
        bulk_export_filename_base
        bulk_export_number_of_months
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def initialize
        @batch_size = 3000
        @aws_region = "eu-west-1"
        @bulk_export_number_of_months = 1
      end

      def ensure_valid
        missing_attributes = ATTRIBUTES.select { |a| public_send(a).nil? }
        return true if missing_attributes.empty?

        raise "The following DefraRuby::Exporters configuration attributes are missing: #{missing_attributes}"
      end
    end
  end
end

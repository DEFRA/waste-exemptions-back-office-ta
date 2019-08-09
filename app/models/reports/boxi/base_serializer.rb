# frozen_string_literal: true

require "csv"

module Reports
  module Boxi
    class BaseSerializer
      def self.export_to_file(dir_path)
        instance = new
        file_path = File.join(dir_path, instance.file_name)

        File.open(file_path, "w") do |file|
          file.write(instance.to_csv)
        end
      end

      def to_csv
        CSV.generate do |csv|
          csv << self.class::ATTRIBUTES

          records do |record|
            csv << record
          end
        end
      end

      def records
        records_scope.find_in_batches(batch_size: batch_size) do |batch|
          batch.each do |record|
            yield serialize_record(record)
          end
        end
      end

      def serialize_record(record)
        self.class::ATTRIBUTES.map do |attribute|
          content = record.public_send(attribute)

          if self.respond_to?("parse_#{attribute}")
            public_send("parse_#{attribute}", content)
          else
            content
          end
        end
      end

      def batch_size
        WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
      end

      def file_name
        raise(NotImplementedError)
      end

      def records_scope
        raise(NotImplementedError)
      end
    end
  end
end

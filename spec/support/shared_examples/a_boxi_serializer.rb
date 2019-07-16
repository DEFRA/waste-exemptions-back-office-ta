# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "A Boxi serializer" do
  let(:instance) { described_class.new }

  describe ".export_to_file" do
    it "generates a csv file with data in the given path" do
      Dir.mktmpdir do |dir_path|
        file_path = File.join(dir_path, instance.file_name)

        expect { described_class.export_to_file(dir_path) }.to change { File.exist?(file_path) }.from(false).to(true)
      end
    end
  end
end

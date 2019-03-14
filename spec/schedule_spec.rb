# frozen_string_literal: true

require "rails_helper"
require "whenever/test"

# This allows us to ensure that the schedules we have declared in whenever's
# (https://github.com/javan/whenever) config/schedule.rb are valid.
# The hope is this saves us from only being able to confirm if something will
# work by actually running the deployment and seeing if it breaks (or not)
# See https://github.com/rafaelsales/whenever-test for more details

RSpec.describe "Whenever schedule", vcr: true do
  before do
    # Makes sure rake tasks are loaded so you can assert in rake jobs
    load "Rakefile"
  end

  it "makes sure 'runner' statements exist" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")

    expect(schedule.jobs[:runner].count).to eq(1)

    # Making the instance_eval call appears to actually kick off the job and
    # therefore involves a hit on S3, hence we have mocked it using VCR
    VCR.use_cassette("save_epr_export_to_s3") do
      # Executes the actual ruby statement to make sure all constants and
      # methods exist:
      schedule.jobs[:runner].each { |job| instance_eval job[:task] }
    end
  end
end

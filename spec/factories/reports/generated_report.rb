# frozen_string_literal: true

FactoryBot.define do
  factory :generated_report, class: Data::GeneratedReport do
    file_name { "20190601-20190630.csv" }
  end
end

# frozen_string_literal: true

RSpec.shared_examples "Renders valid html" do |request_path|
  it "returns W3C valid HTML content" do
    get request_path

    expect(response.body).to have_valid_html
  end
end

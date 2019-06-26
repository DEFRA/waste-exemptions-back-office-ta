# frozen_string_literal: true

RSpec.shared_examples "Renders valid html" do
  it "returns W3C valid HTML content" do
    raise(StandardError, "Missing request_path let variable") if request_path.nil?

    user = create(:user, :system)
    sign_in(user)
    p "START"
    p "USER_ID IN TEST #{user.id}"

    get request_path

    expect(response.body).to have_valid_html
  end
end

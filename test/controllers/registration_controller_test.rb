require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  test "should get identification" do
    get registration_identification_url
    assert_response :success
  end
end

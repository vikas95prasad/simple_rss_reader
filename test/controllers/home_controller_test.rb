require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get help" do
    get home_help_url
    assert_response :success
  end
end

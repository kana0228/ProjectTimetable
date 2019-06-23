require 'test_helper'

class LoginPageControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_page_login_url
    assert_response :success
  end

end

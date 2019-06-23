require 'test_helper'

class ResultControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get result_show_url
    assert_response :success
  end

end

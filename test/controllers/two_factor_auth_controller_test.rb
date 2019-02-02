require 'test_helper'

class TwoFactorAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get two_factor_auth_new_url
    assert_response :success
  end

end

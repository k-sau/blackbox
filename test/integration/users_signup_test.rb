require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup should be rejected" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          name: "",
          email: "user@kumar",
          password: "test",
          password_confirmation: "bar"
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.alert-danger'
  end

  test "valid signup should be accepted" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          name: "Test Admin",
          email: "sbx-test@kumar.ninja",
          password: "passwordqwerty",
          password_confirmation: "passwordqwerty"
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash[:success].empty?
  end
end

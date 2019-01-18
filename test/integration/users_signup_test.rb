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
end

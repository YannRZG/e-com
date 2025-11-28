require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "john@example.com",
      password: "password",
      password_confirmation: "password"
    )
    Current.user = @user
  end

  test "should get index" do
    get users_path, headers: { "Accept" => "text/html" }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get new_user_path
    assert_response :success
    assert assigns(:user).new_record?
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_path, params: {
        user: {
          email_address: "new@example.com",
          password: "secret",
          password_confirmation: "secret"
        }
      }
    end
    assert_redirected_to root_path
  end

  test "should show user" do
    get user_path(@user)
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should destroy current user" do
    assert_difference("User.count", -1) do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end
end

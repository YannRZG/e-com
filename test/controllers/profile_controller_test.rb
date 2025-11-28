require "test_helper"
require "ostruct"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "john@example.com",
      password: "password",
      password_confirmation: "password"
    )
    Current.user = @user
  end

  test "should get show" do
    get profile_path
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should get edit" do
    get edit_profile_path
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should update profile without password" do
    patch profile_path, params: { user: { first_name: "John", last_name: "Doe" } }
    assert_redirected_to profile_path
    @user.reload
    assert_equal "John", @user.first_name
    assert_equal "Doe", @user.last_name
  end

  test "should update profile with correct current password" do
    patch profile_path, params: {
      user: {
        current_password: "password",
        password: "newpassword",
        password_confirmation: "newpassword",
        first_name: "John"
      }
    }
    assert_redirected_to profile_path
    @user.reload
    assert @user.authenticate("newpassword")
    assert_equal "John", @user.first_name
  end

  test "should not update password with wrong current password" do
    patch profile_path, params: {
      user: {
        current_password: "wrong",
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    }
    assert_response :unprocessable_entity
    @user.reload
    assert_not @user.authenticate("newpassword")
  end
end

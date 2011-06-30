require 'test_helper'

class FixturesControllerTest < ActionController::TestCase
  test "should get reset" do
    get :reset
    assert_response :success
  end

end

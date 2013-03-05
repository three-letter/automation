require 'test_helper'

class MessagepoolControllerTest < ActionController::TestCase
  test "should get seq" do
    get :seq
    assert_response :success
  end

end

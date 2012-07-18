require 'test_helper'

class PlaylogControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

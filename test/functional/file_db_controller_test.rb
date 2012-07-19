require 'test_helper'

class FileDbControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

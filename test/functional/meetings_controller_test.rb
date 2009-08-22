require 'test_helper'

class MeetingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meetings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meeting" do
    assert_difference('Meeting.count') do
      post :create, :meeting => { }
    end

    assert_redirected_to meeting_path(assigns(:meeting))
  end

  test "should show meeting" do
    get :show, :id => meetings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => meetings(:one).to_param
    assert_response :success
  end

  test "should update meeting" do
    put :update, :id => meetings(:one).to_param, :meeting => { }
    assert_redirected_to meeting_path(assigns(:meeting))
  end

  test "should destroy meeting" do
    assert_difference('Meeting.count', -1) do
      delete :destroy, :id => meetings(:one).to_param
    end

    assert_redirected_to meetings_path
  end
end

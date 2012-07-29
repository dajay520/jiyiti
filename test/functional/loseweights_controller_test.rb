require 'test_helper'

class LoseweightsControllerTest < ActionController::TestCase
  setup do
    @loseweight = loseweights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:loseweights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create loseweight" do
    assert_difference('Loseweight.count') do
      post :create, loseweight: @loseweight.attributes
    end

    assert_redirected_to loseweight_path(assigns(:loseweight))
  end

  test "should show loseweight" do
    get :show, id: @loseweight
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @loseweight
    assert_response :success
  end

  test "should update loseweight" do
    put :update, id: @loseweight, loseweight: @loseweight.attributes
    assert_redirected_to loseweight_path(assigns(:loseweight))
  end

  test "should destroy loseweight" do
    assert_difference('Loseweight.count', -1) do
      delete :destroy, id: @loseweight
    end

    assert_redirected_to loseweights_path
  end
end

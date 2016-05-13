require 'test_helper'
# Every single method tester here
class HomeControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success, msg: 'ERROR 1: No se puede obtener el index'
  end

  test 'should get json' do
    post :instagram_tag, tag: 'saratscheff'
    assert_response :success, msg: 'ERROR 2: No se puede obtener el instagram_tag'
  end
end

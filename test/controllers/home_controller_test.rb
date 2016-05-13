require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success, msg: "ERROR 1: No se puede obtener el index"
  end

  test "should get json" do
    post :instagram_tag
    assert_response :success, msg: "ERROR 2: No se puede obtener el instagram_tag"
  end

  test "assert true" do
    assert true, msg: "ERROR 0a: ¡¡¡¡¡¡ ESTO JAMÁS DEBERÍA FALLAR !!!!!!"
  end

  test "assert false" do
    assert false, msg: "ERROR 0b: Es un assert false, es normal que falle"
  end

end

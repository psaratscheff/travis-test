require 'test_helper'
# Every single method tester here
class HomeControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success, msg: 'ERROR 1: No se puede obtener el index'
  end

  test 'should get valid json' do
    post :instagram_tag, tag: 'chile'
    assert_response :success, msg: 'ERROR 2: No se puede obtener el instagram_tag'

    json_response = JSON.parse(@response.body)
    Rails.logger.debug json_response.to_s # run 'tail -f log/test.log' in separate terminal
    assert !json_response['metadata'].nil?, msg: 'ERROR 3a: No hay metadata'
    assert !json_response['posts'].nil?, msg: 'ERROR 3b: No hay posts'
    assert !json_response['version'].nil?, msg: 'ERROR 3c: No hay version'
    assert !json_response['metadata']['total'].nil?, msg: 'ERROR 3d: No hay total'
    assert !json_response['posts']['username'].nil?, msg: 'ERROR 3e: No hay username'
  end

  test 'should render an error' do
    post :instagram_tag
    assert_response 400, msg: 'ERROR 4: No se obtuvo código 400 al no incluir parametros'
  end

  test 'should throw exception' do
    post :instagram_tag, tag: '}'
    assert_response 503, msg: 'ERROR 5: No se lanzó la excepción, habiendo forzado una'
  end
end

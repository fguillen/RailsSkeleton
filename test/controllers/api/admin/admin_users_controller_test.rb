require "test_helper"

class Api::Admin::AdminUsersControllerTest < ActionController::TestCase
  def expected_result(admin_user)
    {
      'email' => admin_user.email,
      'id' => admin_user.id,
      'name' => admin_user.name,
      'uuid' => admin_user.uuid
    }
  end

  def assert_unauthorized
    assert_response :unauthorized
  end

  def test_unauthorized
    admin_user = FactoryBot.create(:admin_user)

    get :index
    assert_unauthorized

    get :show, params: { uuid: admin_user.uuid }
    assert_unauthorized

    post :create, params: { admin_user: { email: 'test@example.com', name: 'test admin', password: 'password', password_confirmation: 'password' } }
    assert_unauthorized
    assert_equal admin_user, AdminUser.last

    patch :update, params: { uuid: admin_user.uuid, admin_user: { email: 'test@example.com', name: 'test admin', password: 'password', password_confirmation: 'password' } }
    assert_unauthorized
    assert_equal admin_user, AdminUser.last

    delete :destroy, params: { uuid: admin_user.uuid }
    assert_unauthorized
    assert_nothing_raised do
      admin_user.reload
    end

    request.env['HTTP_AUTHORIZATION'] = 'Token TEST_ADMIN_TOKEN_2'

    get :index
    assert_unauthorized

    request.env['HTTP_AUTHORIZATION'] = 'TEST_ADMIN_TOKEN_2'

    get :index
    assert_unauthorized

    request.env['HTTP_AUTHORIZATION'] = "ScrapStats invalid-token-#{SecureRandom.uuid}"

    get :index
    assert_unauthorized
  end

  def test_index
    request.env['HTTP_AUTHORIZATION'] = 'ScrapStats TEST_ADMIN_TOKEN_2'
    admins = Array.new(3) { FactoryBot.create(:admin_user) }
    get :index

    assert_response :success
    assert_equal admins.map { |admin_user| expected_result(admin_user) }, JSON.parse(response.body)
  end

  def test_show
    request.env['HTTP_AUTHORIZATION'] = 'ScrapStats TEST_ADMIN_TOKEN_2'
    admin_user = FactoryBot.create(:admin_user)

    get :show, params: { uuid: admin_user.uuid }

    assert_response :success
    assert_equal expected_result(admin_user), JSON.parse(response.body)
  end

  def test_create
    request.env['HTTP_AUTHORIZATION'] = 'ScrapStats TEST_ADMIN_TOKEN_2'
    email = 'test@example.com'
    name = 'test admin'
    password = 'p4sswORd'

    post :create, params: { admin_user: { email: email, name: name, password: password, password_confirmation: password } }

    new_admin_user = AdminUser.last

    assert_response :created
    assert_equal email, new_admin_user.email
    assert_equal name, new_admin_user.name
    assert new_admin_user.valid_password?(password)
  end

  def test_update
    request.env['HTTP_AUTHORIZATION'] = 'ScrapStats TEST_ADMIN_TOKEN_2'
    email = 'test@example.com'
    name = 'test admin'
    password = 'p4sswORd'
    admin_user = FactoryBot.create(:admin_user)

    patch :update, params: { uuid: admin_user.uuid, admin_user: { email: email, name: name, password: password, password_confirmation: password } }

    admin_user.reload

    assert_response :success
    assert_equal email, admin_user.email
    assert_equal name, admin_user.name
    assert admin_user.valid_password?(password)
  end

  def test_create_invalid
    request.env['HTTP_AUTHORIZATION'] = 'ScrapStats TEST_ADMIN_TOKEN_2'
    expected_error = "Validation failed: " \
                     "Password is too short (minimum is 8 characters), " \
                     "Password must use at least three of the four available character types: lowercase letters, uppercase letters, numbers, and symbols., " \
                     "Name can't be blank, " \
                     "Email is invalid, " \
                     "Password confirmation doesn't match Password"

    post :create, params: { admin_user: { email: 'invalid', name: '', password: 'lorem', password_confirmation: 'ipsum' } }

    assert_response :unprocessable_entity
    assert_equal({ 'errors' => [expected_error] }, JSON.parse(response.body))
  end

  def test_destroy
    request.env['HTTP_AUTHORIZATION'] = 'ScrapStats TEST_ADMIN_TOKEN_2'
    admin_user_1 = FactoryBot.create(:admin_user)

    delete :destroy, params: { uuid: admin_user_1.uuid }

    assert_response :no_content
    assert_raises ActiveRecord::RecordNotFound do
      admin_user_1.reload
    end
  end
end

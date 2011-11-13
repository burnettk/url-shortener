require File.expand_path('../test_helper', File.dirname(__FILE__))

class LinksControllerTest < ActionController::TestCase
  setup do
    @link = Factory(:link)
    @controller.stubs(:handle_authorization)
  end

  test "should get index" do
    get :index, {}, {:rs_username => 'kburnett'}
    assert_response :success
    assert_not_nil assigns(:my_links)
  end

  test "should get go with rs_username" do
    assert_difference('User.count') do
      get :go, {:path => @link.shortcut}, {:rs_username => 'kburnett'}
    end
    user = User.order('id desc').first
    assert_equal 'kburnett', user.identifier
    assert_response :redirect
  end

  test "should get go with no rs_username" do
    assert_difference('User.count') do
      get :go, {:path => @link.shortcut}
    end
    user = User.order('id desc').first
    assert_equal 'anonymous', user.identifier
    assert_response :redirect
  end

  test "should get new" do
    get :new, {}, {:rs_username => 'kburnett'}
    assert_response :success
  end

  test "should create link" do
    assert_difference('Link.count') do
      post :create, {:link => @link.attributes.merge(:shortcut => 'somethingunique')}, {:rs_username => 'kburnett'}
    end

    assert_redirected_to root_path
  end

  test "should show link" do
    get :show, :id => @link.to_param
    assert_response :success
  end

  test "should get edit with correct user" do
    identifier = 'kburnett'
    user = User.find_or_create_by_identifier(identifier)
    @link.user = user
    @link.save!
    get :edit, {:id => @link.to_param}, {:rs_username => identifier}
    assert_response :success
  end

  test "should get edit with wrong user" do
    identifier = 'kburnett'
    user = User.find_or_create_by_identifier(identifier)
    @link.update_attribute(:user_id, user.id)
    get :edit, {:id => @link.to_param}, {:rs_username => 'someoneelse'}
    assert_response 404
  end

  test "should update link" do
    put :update, {:id => @link.to_param, :link => @link.attributes}, {:rs_username => @link.user.identifier}
    assert_redirected_to root_path
  end

  test "should destroy link" do
    assert_difference('Link.count', -1) do
      delete :destroy, {:id => @link.to_param}, {:rs_username => @link.user.identifier}
    end

    assert_redirected_to links_path
  end
end

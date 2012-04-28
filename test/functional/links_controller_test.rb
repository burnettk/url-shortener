require File.expand_path('../test_helper', File.dirname(__FILE__))

class ShortcutsControllerTest < ActionController::TestCase
  setup do
    @shortcut = FactoryGirl.create(:shortcut)
    @controller.stubs(:handle_authorization)
  end

  test "should get index" do
    get :index, {}, {:rs_username => 'kburnett'}
    assert_response :success
    assert_not_nil assigns(:my_shortcuts)
  end

  test "should get go with rs_username" do
    assert_difference('User.count') do
      get :go, {:path => @shortcut.shortcut}, {:rs_username => 'kburnett'}
    end
    user = User.order('id desc').first
    assert_equal 'kburnett', user.identifier
    assert_response :redirect
  end

  test "should get go with no rs_username" do
    assert_difference('User.count') do
      get :go, {:path => @shortcut.shortcut}
    end
    user = User.order('id desc').first
    assert_equal 'anonymous', user.identifier
    assert_response :redirect
  end

  test "should get new" do
    get :new, {}, {:rs_username => 'kburnett'}
    assert_response :success
  end

  test "should create shortcut" do
    assert_difference('Shortcut.count') do
      post :create, {:shortcut => @shortcut.attributes.merge(:shortcut => 'somethingunique')}, {:rs_username => 'kburnett'}
    end

    assert_redirected_to root_path
  end

  test "should show shortcut" do
    get :show, :id => @shortcut.to_param
    assert_response :success
  end

  test "should get edit with correct user" do
    identifier = 'kburnett'
    user = User.find_or_create_by_identifier(identifier)
    @shortcut.user = user
    @shortcut.save!
    get :edit, {:id => @shortcut.to_param}, {:rs_username => identifier}
    assert_response :success
  end

  test "should get edit with wrong user" do
    identifier = 'kburnett'
    user = User.find_or_create_by_identifier(identifier)
    @shortcut.update_attribute(:user_id, user.id)
    get :edit, {:id => @shortcut.to_param}, {:rs_username => 'someoneelse'}
    assert_response 404
  end

  test "should update shortcut" do
    put :update, {:id => @shortcut.to_param, :shortcut => @shortcut.attributes}, {:rs_username => @shortcut.user.identifier}
    assert_redirected_to root_path
  end

  test "should destroy shortcut" do
    assert_difference('Shortcut.count', -1) do
      delete :destroy, {:id => @shortcut.to_param}, {:rs_username => @shortcut.user.identifier}
    end

    assert_redirected_to shortcuts_path
  end
end

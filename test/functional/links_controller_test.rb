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

    assert_equal 'kburnett', assigns(:shortcut).created_by.identifier
    assert_redirected_to root_path
  end

  test "should show shortcut" do
    get :show, :id => @shortcut.to_param
    assert_response :success
  end

  test "should get edit with correct user" do
    identifier = 'kburnett'
    user = User.find_or_create_by_identifier(identifier)
    @shortcut.created_by = user
    @shortcut.save!
    get :edit, {:id => @shortcut.to_param}, {:rs_username => identifier}
    assert_response :success
  end

  test "should get edit with another user" do
    identifier = 'kburnett'
    user = User.find_or_create_by_identifier(identifier)
    @shortcut.update_attribute(:created_by_user_id, user.id)
    get :edit, {:id => @shortcut.to_param}, {:rs_username => 'someoneelse'}
    assert_response :success
  end

  test "should update shortcut with same user" do
    new_user = @shortcut.created_by.identifier
    put :update, {:id => @shortcut.to_param, :shortcut => @shortcut.attributes}, {:rs_username => new_user}
    assert_nil assigns(:shortcut).updated_by
    assert_redirected_to root_path
  end

  # test "should update shortcut with different user" do
  #   new_user = @shortcut.created_by.identifier + 'withawesome'
  #   put :update, {:id => @shortcut.to_param, :shortcut => @shortcut.attributes.merge(:shortcut => 'hey')}, {:rs_username => new_user}
  #   assert_equal new_user, assigns(:shortcut).reload.updated_by.identifier
  #   assert_redirected_to root_path
  # end

  test "should destroy shortcut" do
    assert_difference('Shortcut.count', -1) do
      delete :destroy, {:id => @shortcut.to_param}, {:rs_username => @shortcut.created_by.identifier}
    end
    assert_nil assigns(:shortcut).updated_by

    assert_redirected_to shortcuts_path
  end

  test "should destroy shortcut with different user" do
    new_user = @shortcut.created_by.identifier + 'withawesome'
    assert_difference('Shortcut.count', -1) do
      delete :destroy, {:id => @shortcut.to_param}, {:rs_username => new_user}
    end
    assert_equal new_user, assigns(:shortcut).updated_by.identifier

    assert_redirected_to shortcuts_path
  end
end

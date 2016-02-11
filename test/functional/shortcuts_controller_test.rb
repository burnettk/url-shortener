require File.expand_path('../test_helper', File.dirname(__FILE__))

class ShortcutsControllerTest < ActionController::TestCase
  setup do
    @shortcut = FactoryGirl.create(:shortcut)
    @user = @shortcut.created_by
    @controller.stubs(:handle_authorization)
  end

  def assert_path_yields_redirect_to(path, redirect_url)
    assert_difference('User.count') do
      get :go, {:path => path}, {:authenticated_username => 'burnettk'}
    end
    user = User.order('id desc').first
    assert_equal 'burnettk', user.identifier
    assert_response :redirect
    assert_redirected_to redirect_url
  end

  def assert_path_yields_folder_page(path, folder_name)
    assert_difference('User.count') do
      get :go, {:path => path}, {:authenticated_username => 'burnettk'}
    end
    assert_response :success
    assert_equal "Shortcuts in folder: #{folder_name}", assigns(:page_title)
  end

  test "should get index" do
    get :index, {}, {:authenticated_username => 'burnettk'}
    assert_response :success
    assert_not_nil assigns(:my_shortcuts)
  end

  test "should get go with authenticated_username" do
    assert_path_yields_redirect_to(@shortcut.shortcut, 'http://mystring')
  end

  test "should get a redirect to expected url when exact match of shortcut" do
    assert_path_yields_redirect_to(@shortcut.shortcut, 'http://mystring')
  end

  test "should get a redirect to expected url when matching wildcard shortcut" do
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'google/%s', :url => 'https://www.google.com/#q=%s', :created_by => @user)
    assert_path_yields_redirect_to('google/hey', 'https://www.google.com/#q=hey')
  end

  test "should yield directory listing when matching directory" do
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo1', :created_by => @user)
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo2', :created_by => @user)
    assert_path_yields_folder_page('hey', 'hey')
  end

  test "should yield directory listing when matching multi level directory" do
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo/1', :created_by => @user)
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo/2', :created_by => @user)
    assert_path_yields_folder_page('hey/yo', 'hey/yo')
  end

  test "should yield exact match in subdirectory even if a wildcard shortcut could also match" do
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/%s', :url => 'http://wildcard.example.com/sure', :created_by => @user)
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo/1', :url => 'http://awesome.example.com', :created_by => @user)
    assert_path_yields_redirect_to('hey/yo/1', 'http://awesome.example.com')
  end

  test "should yield exact match in same directory even if a wildcard shortcut could also match" do
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/%s', :url => 'http://wildcard.example.com/sure', :created_by => @user)
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/1', :url => 'http://awesome.example.com', :created_by => @user)
    assert_path_yields_redirect_to('hey/1', 'http://awesome.example.com')
  end

  test "should yield directory listing when a directory conflicts with a wildcard shortcut" do
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/%s', :url => 'http://wildcard.example.com/sure', :created_by => @user)
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo/1', :created_by => @user)
    @shortcut = FactoryGirl.create(:shortcut, :shortcut => 'hey/yo/2', :created_by => @user)
    assert_path_yields_folder_page('hey/yo', 'hey/yo')
  end

  test "should get go with no authenticated_username" do
    assert_difference('User.count') do
      get :go, {:path => @shortcut.shortcut}
    end
    user = User.order('id desc').first
    assert_equal 'anonymous', user.identifier
    assert_response :redirect
  end

  test "should get new" do
    get :new, {}, {:authenticated_username => 'burnettk'}
    assert_response :success
  end

  test "should create shortcut" do
    assert_difference('Shortcut.count') do
      post :create, {:shortcut => {:url => @shortcut.url, :shortcut => 'somethingunique'}}, {:authenticated_username => 'burnettk'}
    end

    assert_equal 'burnettk', assigns(:shortcut).created_by.identifier
    assert_redirected_to root_path
  end

  test "should show shortcut" do
    get :show, :id => @shortcut.to_param
    assert_response :success
  end

  test "should get edit with correct user" do
    identifier = 'burnettk'
    user = User.where(identifier: identifier).first_or_create
    @shortcut.created_by = user
    @shortcut.save!
    get :edit, {:id => @shortcut.to_param}, {:authenticated_username => identifier}
    assert_response :success
  end

  test "should get edit with another user" do
    identifier = 'burnettk'
    user = User.where(identifier: identifier).first_or_create
    @shortcut.update_attribute(:created_by_user_id, user.id)
    get :edit, {:id => @shortcut.to_param}, {:authenticated_username => 'someoneelse'}
    assert_response :success
  end

  test "should update shortcut with same user" do
    new_user = @shortcut.created_by.identifier
    put :update, {:id => @shortcut.to_param, :shortcut => {:url => @shortcut.url, :shortcut => @shortcut.url}}, {:authenticated_username => new_user}
    assert_nil assigns(:shortcut).updated_by
    assert_redirected_to root_path
  end

  # test "should update shortcut with different user" do
  #   new_user = @shortcut.created_by.identifier + 'withawesome'
  #   put :update, {:id => @shortcut.to_param, :shortcut => @shortcut.attributes.merge(:shortcut => 'hey')}, {:authenticated_username => new_user}
  #   assert_equal new_user, assigns(:shortcut).reload.updated_by.identifier
  #   assert_redirected_to root_path
  # end

  test "should destroy shortcut" do
    assert_difference('Shortcut.count', -1) do
      delete :destroy, {:id => @shortcut.to_param}, {:authenticated_username => @shortcut.created_by.identifier}
    end
    assert_nil assigns(:shortcut).updated_by

    assert_redirected_to shortcuts_path
  end

  test "should destroy shortcut with different user" do
    new_user = @shortcut.created_by.identifier + 'withawesome'
    assert_difference('Shortcut.count', -1) do
      delete :destroy, {:id => @shortcut.to_param}, {:authenticated_username => new_user}
    end
    assert_equal new_user, assigns(:shortcut).updated_by.identifier

    assert_redirected_to shortcuts_path
  end
end

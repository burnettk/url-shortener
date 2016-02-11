require File.expand_path('../test_helper', File.dirname(__FILE__))

class ShortcutTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
  end

  test "empty path is bad" do
    shortcut = FactoryGirl.build(:shortcut, :shortcut => '', :url => 'http://', :created_by => @user)
    assert_equal false, shortcut.valid?
    assert_equal "Shortcut can't be blank", shortcut.errors.full_messages.first
  end

  test "single slash is bad" do
    shortcut = FactoryGirl.build(:shortcut, :shortcut => '/', :url => 'http://', :created_by => @user)
    assert_equal false, shortcut.valid?
    assert_equal "Shortcut must not be a single slash", shortcut.errors.full_messages.first
  end

  test "process_path_for_user!" do
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'j', :url => 'http://jazz', :created_by => @user)
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'j/%s', :url => 'http://jazz/workitem/%s', :created_by => @user)
    assert_finds_url('http://jazz', 'j', @user)
    assert_finds_url('http://jazz/workitem/3', 'j/3', @user)
  end

  test "find_by_path escapes spaces in the wildcard substituted input" do
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'ml/%s', :url => 'http://people.lan.flt/mailing_lists/members/%s', :created_by => @user)
    assert_finds_url('http://people.lan.flt/mailing_lists/members/@RS%20Core%20Platform', 'ml/@RS Core Platform', @user)
  end

  test "find_by_path picks the best match" do
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'svn/%s', :url => 'http://svn/%s', :created_by => @user)
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'vipersvn/%s', :url => 'http://svn/viper/%s', :created_by => @user)
    assert_finds_url('http://svn/viper/hey', 'vipersvn/hey', @user)
    assert_finds_url('http://svn/hey', 'svn/hey', @user)
  end

  test "find_by_path does not double escape" do
    url = 'https://jazz.lan.flt:9443/jazz/web/projects/SDQA#action=com.ibm.team.dashboard.viewDashboard&team=Core%20Platform&tab=_2'
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'dashboard', :url => url, :created_by => @user)
    assert_finds_url(url, 'dashboard', @user)
  end

  test "shortcuts must not contain spaces" do
    shortcut = FactoryGirl.build(:shortcut, :shortcut => 'j %s', :url => 'http://jazz/%s', :created_by => @user)
    assert_equal false, shortcut.valid?
    assert_equal 'Shortcut must not contain spaces', shortcut.errors.full_messages.first
  end

  test "shortcuts must have at least one character and one slash before a wildcard" do
    shortcut = FactoryGirl.build(:shortcut, :shortcut => 'wi%s', :url => 'http://jazz/%s', :created_by => @user)
    assert_equal false, shortcut.valid?
    assert_match /must have at least one character and one slash/, shortcut.errors.full_messages.first
  end

private
  def assert_finds_url(expected_url, path, user)
    assert_difference('user.shortcut_visits.count') do
      assert_equal({:url => expected_url}, Shortcut.process_path_for_user!(path, user))
    end
  end
end

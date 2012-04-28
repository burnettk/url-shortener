require File.expand_path('../test_helper', File.dirname(__FILE__))

class ShortcutTest < ActionDispatch::IntegrationTest

  setup do
    @user = FactoryGirl.create(:user)
  end

  test "getting a shortcut with a period/dot in the url" do
    shortcut = FactoryGirl.create(:shortcut, :shortcut => 'lmsvn/%s', :url => 'https://trac.lan.flt/swdev/browser/Projects/LearnerManagement/%s?format=raw', :user => @user)
    get 'lmsvn/RSM_JaKo_ReFLEX/Release_Note_RSM_ReFLEX_JaKo.docx'
    assert_redirected_to 'https://trac.lan.flt/swdev/browser/Projects/LearnerManagement/RSM_JaKo_ReFLEX/Release_Note_RSM_ReFLEX_JaKo.docx?format=raw'
  end

end

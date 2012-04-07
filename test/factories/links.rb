# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    shortcut "MyString"
    url "http://mystring"
    association :user, :factory => :user
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shortcut do
    shortcut "MyString"
    url "http://mystring"
    association :created_by, :factory => :user
  end
end

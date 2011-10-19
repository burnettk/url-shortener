# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :link do |f|
  f.shortcut "MyString"
  f.url "http://mystring"
  f.association :user, :factory => :user
end

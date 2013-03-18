class ShortcutVisit < ActiveRecord::Base
  belongs_to :shortcut
  belongs_to :user

  attr_accessible :shortcut, :path
end

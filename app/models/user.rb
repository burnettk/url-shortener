class User < ActiveRecord::Base
  has_many :shortcuts, :dependent => :destroy, :foreign_key => 'created_by_user_id'
  has_many :visited_shortcuts, :through => :shortcut_visits, :class_name => :shortcut
  has_many :shortcut_visits, :dependent => :destroy
end

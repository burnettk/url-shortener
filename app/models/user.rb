class User < ActiveRecord::Base
  has_many :links, :dependent => :destroy
  has_many :visited_links, :through => :link_visits, :class_name => :link
  has_many :link_visits, :dependent => :destroy
end

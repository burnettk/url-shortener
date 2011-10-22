class Link < ActiveRecord::Base
  belongs_to :user
  has_many :link_visits, :dependent => :destroy
  has_many :users, :through => :link_visits

  validates_uniqueness_of :shortcut
  validates_format_of :url, :with => /^http/, :message => 'must start with http'

  scope :wildcards, where("shortcut like '%\\%s%'")

  attr_accessor :matched_segment

  class << self

    def process_path_for_user!(path, user)
      if link = find_by_path(path)
        user.link_visits.create(:link => link, :path => path)
        link.generated_url
      end
    end

    # nice and scalable
    def find_by_path(path)
      where(['shortcut = ?', path]).first || Link.wildcards.detect {|l| l.matches?(path) }
    end

  end

  def matches?(path)
    regex = shortcut.gsub('%s', '(.*)')
    if matchdata = Regexp.new(regex).match(path)
      self.matched_segment = matchdata.captures.first
    end
  end

  def generated_url
    if matched_segment
      url.sub('%s', matched_segment)
    else
      url
    end
  end
end

class Link < ActiveRecord::Base
  belongs_to :user
  has_many :link_visits, :dependent => :destroy
  has_many :users, :through => :link_visits

  validates_uniqueness_of :shortcut
  validates_presence_of :shortcut
  validate :validate_format_of_shortcut
  validates_format_of :url, :with => /^http/, :message => 'must start with http'

  scope :wildcards, where("shortcut like '%\\%s%'")
  scope :not_for_user, lambda {|user|
    where("user_id != :user_id", {:user_id => user.id})
  }

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
    if matchdata = Regexp.new('^' + regex + '$').match(path)
      self.matched_segment = matchdata.captures.first
    end
  end

  def generated_url
    if matched_segment
      url.sub('%s', Addressable::URI.encode(matched_segment))
    else
      url
    end
  end

  def validate_format_of_shortcut
    return if shortcut.nil?

    if shortcut.include?(' ')
      errors.add(:shortcut, 'must not contain spaces')
    elsif shortcut.to_s.strip == '/'
      errors.add(:shortcut, 'must not be a single slash')
    elsif shortcut.include?('%s')
      if shortcut !~ /\w\/.*\%s/
        errors.add(:shortcut, 'must have at least one character and one slash before a %s (wildcard). Use this convention: j/%s')
      end
    end  
  end
end

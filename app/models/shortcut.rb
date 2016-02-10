class Shortcut < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by_user_id'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by_user_id'
  has_many :shortcut_visits, :dependent => :destroy
  has_many :users, :through => :shortcut_visits

  validates_uniqueness_of :shortcut
  validates_presence_of :shortcut
  validate :validate_format_of_shortcut
  validates_format_of :url, :with => /\Ahttp/, :message => 'must start with http'

  scope :wildcards, -> {
    where("shortcut like '%\\%s%'")
  }
  scope :not_for_user, lambda {|user|
    where("created_by_user_id != :user_id", {:user_id => user.id})
  }

  attr_accessor :matched_segment
  attr_accessible :url, :shortcut

  class << self

    def process_path_for_user!(path, user)
      if shortcut = find_exact_match_by_path(path)
        found_it(user, shortcut, path)
      elsif Folder.shortcuts_by_folder(path).any?
        {:folder => path}
      elsif shortcut = find_wildcard_by_path(path)
        found_it(user, shortcut, path)
      else
        {}
      end
    end

    def found_it(user, shortcut, path)
      user.shortcut_visits.create(:shortcut => shortcut, :path => path)
      {:url => shortcut.generated_url}
    end

    # nice and scalable
    def find_exact_match_by_path(path)
      where(['shortcut = ?', path]).first
    end

    def find_wildcard_by_path(path)
      Shortcut.wildcards.detect {|l| l.matches?(path) }
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

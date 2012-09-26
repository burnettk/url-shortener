require 'addressable/uri'

class ShortcutsController < InheritedResources::Base

  before_filter :set_page_title
  before_filter :buzz_off, :only => [:update, :edit, :destroy]
  
  skip_before_filter :handle_authorization, :only => :go

  def go
    path = params[:path]
    destination_url = Shortcut.process_path_for_user!(path, find_user)
    if destination_url
      redirect_to destination_url
    elsif Namespace.shortcuts_by_namespace(path).any?
      params[:id] = path
      by_namespace
    else
      render_404
    end
  end

  def popular
    @page_title = 'Popular Shortcuts'
    @shortcuts = Shortcut.joins('left join shortcut_visits on shortcut_visits.shortcut_id = shortcuts.id').select('shortcuts.*, count(shortcut_visits.id) as visit_count').group('shortcuts.id').order('visit_count desc').limit(5).all
  end

  def index
    @page_title = 'Shortcuts'
    @other_shortcuts = Shortcut.not_for_user(find_user).limit(5).order('rand()').all
    @my_shortcuts = find_user.shortcuts.order('created_at desc').limit(6).all
  end

  def by_namespace
    namespace = params[:id]
    @page_title = "Shortcuts in namespace: #{namespace}"
    @shortcuts = Namespace.shortcuts_by_namespace(namespace)
    render 'shortcut_page'
  end

  def all
    @page_title = 'All Shortcuts'
    @shortcuts = Shortcut.order('shortcut').all
  end

  def my
    @page_title = 'My Shortcuts'
    @my_shortcuts = find_user.shortcuts.order('created_at desc').all
  end

  def new
    @shortcut = Shortcut.new(:url => 'http://') # to default text box
    new!
  end

  def create
    create! { root_url }
  end

  def update
    update! { root_url }
  end

private

  def find_user
    User.find_or_create_by_identifier(session[:rs_username] || 'anonymous')
  end
    
  def build_resource
    super
    @shortcut.user_id = find_user.id
    @shortcut
  end

  def set_page_title
    prefix = %w(new edit).include?(action_name) ? action_name.titleize + " " : ""
    prefix = 'New ' if action_name == 'create'
    @page_title = prefix + "Shortcut"
  end

  def buzz_off
    shortcut = Shortcut.find(params[:id])
    if shortcut.user != find_user
      render_404
    end
  end
end

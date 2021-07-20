require 'addressable/uri'

class ShortcutsController < InheritedResources::Base

  before_filter :set_page_title
  skip_before_filter :handle_authorization, :only => :go

  def go
    path = params[:path]
    result = Shortcut.process_path_for_user!(path, find_user)
    if result[:url]
      redirect_to result[:url]
    elsif result[:folder]
      params[:id] = result[:folder]
      by_folder
    else
      render_404
    end
  end

  def popular
    @page_title = 'Popular Shortcuts'
    @shortcuts = Shortcut.joins('left join shortcut_visits on shortcut_visits.shortcut_id = shortcuts.id').select('shortcuts.*, count(shortcut_visits.id) as visit_count').group('shortcuts.id').order('visit_count desc').limit(50).all
  end

  def index
    @page_title = 'Shortcuts'
    @popular_shortcuts = Shortcut.joins('left join shortcut_visits on shortcut_visits.shortcut_id = shortcuts.id').select('shortcuts.*, count(shortcut_visits.id) as visit_count').group('shortcuts.id').order('visit_count desc').limit(5).all.to_a
    @my_shortcuts = find_user.shortcuts.order('created_at desc').limit(6).all
    @show_all_folders = false
    @folders = Shortcut.find_by_sql("select left(shortcut, instr(shortcut, '/') - 1) as folder, count(*) count from shortcuts where deleted_at is null group by folder having count > 1 and folder != '' order by count desc limit 6")
  end

  def by_folder
    folder = params[:id]
    @page_title = "Shortcuts in folder: #{folder}"
    @shortcuts = Folder.shortcuts_by_folder(folder)
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
    identifier = session[:authenticated_username] || 'anonymous'
    User.where(identifier: identifier).first_or_create
  end

  def build_resource
    super
    @shortcut.created_by_user_id = find_user.id if action_name == 'create'
    @shortcut
  end

  def resource
    super
    @shortcut.updated_by_user_id = find_user.id if @shortcut.id && @shortcut.created_by_user_id != find_user.id && %w(destroy update).include?(action_name)
    @shortcut
  end

  def destroy_resource(object)
    object.update_attribute(:updated_by_user_id, find_user.id) if @shortcut.id && @shortcut.created_by_user_id != find_user.id
    super
  end

  def set_page_title
    prefix = %w(new edit).include?(action_name) ? action_name.titleize + " " : ""
    prefix = 'New ' if action_name == 'create'
    @page_title = prefix + "Shortcut"
  end
end

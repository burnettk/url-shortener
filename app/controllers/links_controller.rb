require 'addressable/uri'

class LinksController < InheritedResources::Base

  before_filter :set_page_title
  before_filter :buzz_off, :only => [:update, :edit, :destroy]
  
  skip_before_filter :handle_authorization, :only => :go

  def go
    destination_url = Link.process_path_for_user!(params[:path], find_user)
    if destination_url
      redirect_to destination_url
    else
      render_404
    end
  end

  def popular
    @page_title = 'Popular Shortcuts'
    @links = Link.joins('left join link_visits on link_visits.link_id = links.id').select('links.*, count(link_visits.id) as visit_count').group('links.id').order('visit_count desc').limit(5).all
  end

  def index
    @page_title = 'Shortcuts'
    @other_links = Link.not_for_user(find_user).limit(5).order('rand()').all
    @my_links = find_user.links.order('created_at desc').limit(6).all
  end

  def my
    @page_title = 'My Shortcuts'
    @my_links = find_user.links.order('created_at desc').all
  end

  def new
    @link = Link.new(:url => 'http://') # to default text box
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
    @link.user_id = find_user.id
    @link
  end

  def set_page_title
    prefix = %w(new edit).include?(action_name) ? action_name.titleize + " " : ""
    prefix = 'New ' if action_name == 'create'
    @page_title = prefix + "Shortcut"
  end

  def buzz_off
    link = Link.find(params[:id])
    if link.user != find_user
      render_404
    end
  end
end

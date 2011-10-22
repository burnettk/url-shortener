class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :handle_authorization, :except => [:sign_out]

private
  def render_404
    render :text => '<h1>Page not found</h1>', :status => 404
    true  # so we can do "render_404 and return"
  end

  def handle_authorization
    CASClient::Frameworks::Rails::Filter.filter(self)
    set_rs_from_casfilteruser
  end

  def set_rs_from_casfilteruser
    return if session[:rs_username]
    if user_name = session[:casfilteruser]
      session[:rs_username] = user_name
    end
  end
end

class AuthenticationController < ApplicationController

  def sign_out
    session[:casfilteruser] = nil
    CASClient::Frameworks::Rails::Filter.logout(self) # this resets the session!
  end

end

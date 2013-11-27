class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  #before_action LoginFilter
=begin
  before_action :authenticate

  private
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      #Here we request Google+ server with provided token and after that
      token == TOKEN
    end
  end
=end
end

class LoginFilter
  def self.filter(controller)
    unless controller.send(:logged_in?)
      controller.flash[:error] = "You must be logged in"
      controller.redirect_to controller.new_login_url
    end
  end
end
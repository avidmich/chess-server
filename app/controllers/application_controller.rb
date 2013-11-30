require 'google/api_client'
require 'google/api_client/auth/installed_app'
require 'google_api_client_secrets'
class ApplicationController < ActionController::Base

  #Prevent CSRF attacks by raising an exception.
  #For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :authenticate

  private
  #This method gets token from android client (using Authorization request header) and asks Google+ services for access token and user identity
  #After that it matches obtained user identity with the same value stored in our database.
  #If user is found it is set to the @current_user variable for further work, if not - 401 response is returned to the client
  def authenticate
    authenticate_or_request_with_http_token do |one_time_token, options|
      #convert client secrets to authorization object
      authorization = GoogleApiClientSecrets.to_authorization
      authorization.code = one_time_token

      begin
        authorization.fetch_access_token!
      rescue Signet::AuthorizationError
        next false #next is like 'return' but 'return' goes out of 'authenticate' method, while 'next' returns only the closure
      end

      #decoding received ID token into a hash of values according to JWT mechanism
      auth_info = authorization.decoded_id_token
      # You can read the Google user ID in the ID token.
      # "sub" represents the ID token subscriber which in our case is the user ID.
      google_plus_id = auth_info['sub']
      #todo: consider add user_id to the request. In that case it is not sufficient to just add id: params[:user_id], since some requests doesn't contain :user_id param (but contain :id)
      @current_user = User.find_by(google_plus_id: google_plus_id)
      @current_user
    end
  end
end


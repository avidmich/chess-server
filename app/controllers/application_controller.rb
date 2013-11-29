require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class ApplicationController < ActionController::Base

  #Prevent CSRF attacks by raising an exception.
  #For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :authenticate

  #Reading client credentials from client_secrets.json to the constant for further use in authentication flow
  CLIENT_SECRETS = Google::APIClient::ClientSecrets.load

  private
  #This method gets token from android client (using Authorization request header) and asks Google+ services for access token and user identity
  #After that it matches obtained user identity with the same value stored in our database.
  #If user is found it is set to the @current_user variable for further work, if not - 401 response is returned to the client
  def authenticate
    authenticate_or_request_with_http_token do |one_time_token, options|
      #convert client secrets to authorization object
      authorization = CLIENT_SECRETS.to_authorization
      authorization.code = one_time_token
      authorization.fetch_access_token!

      #decoding received ID token into a hash of values according to JWT mechanism
      auth_info = authorization.decoded_id_token
      # You can read the Google user ID in the ID token.
      # "sub" represents the ID token subscriber which in our case is the user ID.
      google_plus_id = auth_info['sub']
      #todo: replace current email field with gplus_id
      @current_user = User.find_by(email: google_plus_id, id: params[:user_id])
      @current_user
    end
  end
end


require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  #before_action LoginFilter
  before_action :authenticate

  # Configuration for the Google+ client
  APPLICATION_NAME = 'Ultimate Chess'
  PLUS_LOGIN_SCOPE = 'https://www.googleapis.com/auth/plus.login'



  private
  #This method gets token from android client (using Authorization request header) and asks Google+ services for access token and user identity
  #After that it matches obtained user identity with the same value stored in our database.
  #If user is found it is set to the @current_user variable for further work, if not - 401 response is returned to the client
  def authenticate
    authenticate_or_request_with_http_token do |one_time_token, options|
      #Here we request Google+ server with provided token and after that
      # todo: Build the global client
      @credentials = Google::APIClient::ClientSecrets.load
      @authorization = Signet::OAuth2::Client.new(
          :authorization_uri => @credentials.authorization_uri,
          :token_credential_uri => @credentials.token_credential_uri,
          :client_id => @credentials.client_id,
          :client_secret => @credentials.client_secret,
          :redirect_uri => @credentials.redirect_uris.first,
          :scope => PLUS_LOGIN_SCOPE)
      @client = Google::APIClient.new


      # Initialize the client.
      @authorization.code = one_time_token
      @authorization.fetch_access_token!
      @client.authorization = @authorization

      id_token = @client.authorization.id_token
      encoded_json_body = id_token.split('.')[1]
      # Base64 must be a multiple of 4 characters long, trailing with '='
      encoded_json_body += (%w(=) * (encoded_json_body.length % 4)).join('')
      json_body = Base64.decode64(encoded_json_body)
      body = JSON.parse(json_body)
      # You can read the Google user ID in the ID token.
      # "sub" represents the ID token subscriber which in our case
      # is the user ID. This sample does not use the user ID.
      gplus_id = body['sub']
      #todo: replace current emaail field with gplus_id
      @current_user = User.find_by_email(gplus_id)
      @current_user
    end
  end
end


require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  #before_action LoginFilter
  #before_action :authenticate

  private
  #This method gets token from android client (using Authorization request header) and asks Google+ services for access token and user identity
  #After that it matches obtained user identity with the same value stored in our database.
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      #Here we request Google+ server with provided token and after that
      # Initialize the client.


      client = Google::APIClient.new
      key = Google::APIClient::KeyUtils.load_from_pkcs12('3f1e988a0bcdb2448503ea38b654ebc287518131-privatekey.p12', 'notasecret')

      client.authorization = Signet::OAuth2::Client.new(
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          audience: 'https://accounts.google.com/o/oauth2/token',
          scope: 'https://www.googleapis.com/auth/userinfo.email',
          issuer: '649688438031-v9nim7ns9394flpamsutt5gplhh9a1ds@developer.gserviceaccount.com',
          signing_key: key,
          person: '649688438031-7j5p6h4mgioqhov8o5ce902kpkcl6arm.apps.googleusercontent.com')

      token = client.authorization.fetch_access_token!
      directory = client.discovered_api('plus')

      # Make an API call.
      result = client.execute(
          :api_method => plus.people.get,
          :parameters => {'collection' => 'public', 'userId' => 'me'}
      )


=begin
      client = Google::APIClient.new(
          :application_name => 'Auth app',
          :application_version => '0.0.1'
      )
      # Initialize Google+ API. Note this will make a request to the
      # discovery service every time, so be sure to use serialization
      # in your production code. Check the samples for more details.
      plus = client.discovered_api('plus')

      # Load client secrets from your client_secrets.json.
      client_secrets = Google::APIClient::ClientSecrets.load

      # Run installed application flow. Check the samples for a more
      # complete example that saves the credentials between runs.
      flow = Google::APIClient::InstalledAppFlow.new(
          :client_id => client_secrets.client_id,
          :client_secret => client_secrets.client_secret,
          :scope => ['https://www.googleapis.com/auth/plus.me']
      )
      client.authorization = flow.authorize
=end



      puts result.data


      puts token
      token
    end
  end
end

class LoginFilter
  def self.filter(controller)
    unless controller.send(:logged_in?)
      controller.flash[:error] = "You must be logged in"
      controller.redirect_to controller.new_login_url
    end
  end
end
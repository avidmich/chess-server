require 'google/api_client'
require 'google/api_client/auth/installed_app'
require 'google_api_client_secrets'
require 'openssl'
require 'base64'
class ApplicationController < ActionController::Base

  #Prevent CSRF attacks by raising an exception.
  #For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  #before_action :verify_authentication
  before_action :authenticate, except: [:version]

  private


  def authenticate
    authenticate_or_request_with_http_token do |signature, _|
      verify(signature, request.body.string)
    end
  end

  SECRET_TOKEN = 'arrow labs chess secret'
  def encode(message)
    sha1 = OpenSSL::Digest::Digest.new('sha1')
    tag = OpenSSL::HMAC.digest(sha1, SECRET_TOKEN, message)
    Base64.strict_encode64(tag).gsub!(/=+$/, '')
  end

  def verify(signature, message)
    logger.warn "Actual signature: #{signature}"
    encoded = encode(message)
    logger.warn "Expected signature: #{encoded}"
    #this is a time attack blocker
    actual = Digest::SHA1.hexdigest(signature)
    logger.warn "Actual encoded signature: #{actual}"
    expected = Digest::SHA1.hexdigest(encoded)
    logger.warn "Expected encoded signature: #{expected}"
    expected == actual
  end


  #This method gets token from android client (using Authorization request header) and asks Google+ services for access token and user identity
  #After that it matches obtained user identity with the same value stored in our database.
  #If user is found it is set to the @current_user variable for further work, if not - 401 response is returned to the client
  def verify_authentication
    authenticate_or_request_with_http_token do |one_time_token, _|
      #convert client secrets to authorization object
      Rails.logger.level = 0
      logger.debug "One time token received: #{one_time_token}"
      authorization = GoogleApiClientSecrets.to_authorization
      logger.debug "Redirect URIs: #{authorization.redirect_uri}"
      authorization.code = one_time_token

      begin
        authorization.fetch_access_token!
      rescue Signet::AuthorizationError => e
        logger.debug "Authorization error occurred: #{e.message}"
        next false #next is like 'return' but 'return' goes out of 'authenticate' method, while 'next' returns only the closure
      end

      #decoding received ID token into a hash of values according to JWT mechanism
      auth_info = authorization.decoded_id_token
      # You can read the Google user ID in the ID token.
      # "sub" represents the ID token subscriber which in our case is the user ID.
      gplus_id = auth_info['sub']
      logger.debug "Google authorization procedure successful with Google+ ID: #{gplus_id}"
      #todo: consider add user_id to the request. In that case it is not sufficient to just add id: params[:user_id], since some requests doesn't contain :user_id param (but contain :id)
      @current_user = User.find_by(gplus_id: gplus_id)
      logger.debug "Internal authorization procedure successful, current user: #{@current_user.to_json}"
      Rails.logger.level = 1
      @current_user
    end
  end
end


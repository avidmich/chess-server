require 'google/api_client/client_secrets'
module GoogleApiClientSecrets
  def self.client_secrets
    @client_secrets ||= Google::APIClient::ClientSecrets.load
  end

  def self.to_authorization
    self.client_secrets.to_authorization
  end
end
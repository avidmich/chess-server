require 'blather/client/client'

class GCMCommunicator
  def initialize(jid, password, host, port, certs)
    @received_messages = []
    @client = Blather::Client.setup(jid, password, host, port, certs)
  end

  def get_im(expected_im)
    @client.register_handler :message, :chat?, :body do |message_with_body|
      message_body = message_with_body.body
      @received_messages << message_body
      puts "Got message ##{(@received_messages.index(message_body) + 1)}: '#{message_body}'"
      @client.close if (message_body == expected_im)
    end
    EM.run{
      @t0 = Time.new # unused for now, but intended to be used for the timeout.
      @client.run
    }
    # Check that the last message we received was the expected one.
    # This is a little redundant (in the absence of a timeout) as we will
    # only get this far if we close the client by finding the expected_im.
    if (@received_messages[-1] == expected_im)
      return true
    else
      return false
    end
  end

end

GCMCommunicator.new('1098077652074@gcm.googleapis.com', 'AIzaSyCAPZQ7GDiVXSdLPMeYNhTz6hbO6Q3Rdao', 'gcm.googleapis.com', 5235, './certs').get_im('adsf')
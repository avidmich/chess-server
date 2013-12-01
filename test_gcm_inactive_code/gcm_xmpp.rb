require 'rubygems'
require 'blather/client/dsl'
require 'blather/client'
$stdout.sync = true

module GCMCommunicator
  extend Blather::DSL

  def self.run;
    client.run
  end

  setup '1098077652074@gcm.googleapis.com', 'AIzaSyCAPZQ7GDiVXSdLPMeYNhTz6hbO6Q3Rdao', 'gcm.googleapis.com', 5235, './certs'

  subscription :request? do |s|
    write_to_stream s.approve!
  end


  status :from => /pong@your\.jabber\.server/ do |s|
    puts "serve!"
    say s.from, 'ping'
  end

  message :chat?, :body do |m|
    puts "ping!"
    @message = {
        to: "#{@registration_id}",
        message_id: "m-1366082849205",
        data: {hello: "world"},
        time_to_live: "600",
        delay_while_idle: true
    }
    say m.from, "<message><gcm xmlns='google:mobile:data'>#{@message}</gcm></message>"
  end

  say '1098077652074@gcm.googleapis.com', 'Hi there'
end

trap(:INT) { EM.stop }
trap(:TERM) { EM.stop }
EM.run do
  GCMCommunicator.run
end
require 'spec_helper'

describe DevicesController do
  describe 'Devices routing' do

    it 'routes to #register' do
      post('/users/1/register').should  route_to(format: :json, controller: 'devices', action: 'register', user_id: '1')
    end

    it 'routes to #register' do
      post('/users/1/unregister').should route_to(format: :json, controller: 'devices', action: 'unregister', user_id: '1')
    end
  end
end

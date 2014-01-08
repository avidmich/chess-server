require 'spec_helper'

describe VersionController do
  describe 'routing' do

    it 'routes to #version' do
      get('/version').should route_to('version#version', format: :json)
    end

  end
end

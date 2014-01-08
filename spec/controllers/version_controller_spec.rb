require 'spec_helper'

describe VersionController do


  describe 'GET version' do
    it 'should return UPDATE_REQUIRED' do
      get :version, {format: :json, version: '0.0.0', build: '18'}
      response.status.should eq(200)
      response.body.should eq('UPDATE_REQUIRED')

    end
    it 'should return UPDATE_NOT_REQUIRED' do
      get :version, {format: :json, version: '1.1.1', build: '18'}
      response.status.should eq(200)
      response.body.should eq('UPDATE_NOT_REQUIRED')
    end
  end
end

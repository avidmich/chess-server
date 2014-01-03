require 'spec_helper'

describe UsersController do
  describe 'routing' do

    it 'routes to #index' do
      get('/users').should route_to('users#index', format: :json)
    end

    it 'routes to #new' do
      get('/users/new').should route_to('users#new', format: :json)
    end

    it 'routes to #show' do
      get('/users/1').should route_to('users#show', :id => '1', format: :json)
    end

    it 'routes to #edit' do
      get('/users/1/edit').should route_to('users#edit', :id => '1', format: :json)
    end

    it 'routes to #create' do
      post('/users').should route_to('users#create', format: :json)
    end

    it 'routes to #update' do
      put('/users/1').should route_to('users#update', :id => '1', format: :json)
    end

    it 'routes to #destroy' do
      delete('/users/1').should route_to('users#destroy', :id => '1', format: :json)
    end

  end
end

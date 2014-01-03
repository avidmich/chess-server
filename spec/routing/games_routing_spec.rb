require 'spec_helper'

describe GamesController do
  describe 'routing' do

    it 'routes to #add_moves' do
      post('/games/2/moves').should route_to(format: :json, controller: 'games', action: 'add_moves', id: '2')
    end

    it 'routes to #index' do
      get('/users/1/games').should route_to('games#index', user_id: '1', format: :json)
    end

    it 'routes to #new' do
      get('/users/1/games/new').should route_to('games#new', user_id:'1', format: :json)
    end

    it 'routes to #show' do
      get('/games/1').should route_to('games#show', :id => '1', format: :json)
    end

    it 'routes to #edit' do
      get('/games/1/edit').should route_to('games#edit', :id => '1', format: :json)
    end

    it 'routes to #create' do
      post('/users/1/games').should route_to('games#create', user_id: '1', format: :json)
    end

    it 'routes to #update' do
      put('/games/1').should route_to('games#update', :id => '1', format: :json)
    end

    it 'routes to #destroy' do
      delete('/games/1').should route_to('games#destroy', :id => '1', format: :json)
    end

  end
end

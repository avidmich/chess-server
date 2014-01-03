require 'spec_helper'

describe FeedbacksController do
  describe 'routing' do

    it 'routes to #index' do
      get('/feedbacks').should route_to('feedbacks#index', format: :json)
    end


    it 'routes to #show' do
      get('/feedbacks/1').should route_to('feedbacks#show', :id => '1', format: :json)
    end


    it 'routes to #create' do
      post('/feedbacks').should route_to('feedbacks#create', format: :json)
    end


    it 'routes to #destroy' do
      delete('/feedbacks/1').should route_to('feedbacks#destroy', :id => '1', format: :json)
    end

  end
end

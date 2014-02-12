ChessServer::Application.routes.draw do

  get '/version' => 'version#version', defaults: { format: :json }
  get '/users/search' => 'users#show', defaults: { format: :json }
  post '/games/:id/moves' => 'games#add_moves', defaults: {format: :json}
  post '/games/:id/draw' => 'games#draw', defaults: {format: :json}
  post '/users/:user_id/register' => 'devices#register', defaults: {format: :json}
  post '/users/:user_id/unregister' => 'devices#unregister', defaults: {format: :json}

  resources :users, shallow: true, defaults: {format: :json} do
    resources :games, defaults: {format: :json}
    #resource :invitations   #todo: implement invitations resource under the same context
  end

  resources :feedbacks, defaults: {format: :json}

  root 'dashboard#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

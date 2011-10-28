Mantropy::Application.routes.draw do

  get "irc/index"

  get "home/index"

  resources :browsenodeids

  root :to => 'home#index'
  resources :series, :except => [:new, :show]
  resources :posts, :except => :destroy
  resources :topics, :except => :destroy
  resources :books, :except => :destroy
  resources :ranks

  resources :users, :only => [:index, :create, :update, :edit, :new]

  match '/series/new(/:id)' => 'series#new', :as => 'new_serie'
  match '/:name/series/:id' => 'series#show', :as => 'serie'
  match '/series/:id' => 'series#show'
  match '/users/:name' => 'users#show', :as => 'user'
  devise_for :userauths, :controllers =>{:registrations => "devise_registrations"}
  match '/search' => 'series#search', :as => 'serie_search'
  match '/ranking(/:str)' => 'series#ranking', :as => 'serie_ranking'
  match '/irc' => 'irc#index', :as => 'irc'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

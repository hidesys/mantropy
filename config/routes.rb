Mantropy::Application.routes.draw do

  get "home/robots"
  get "irc/index"
  get "home/index"

  resources :browsenodeids

  root :to => 'home#index'
  resources :series, :except => [:new, :show, :update]
  resources :posts, :except => :destroy
  resources :topics, :except => [:destroy, :show]
  resources :books, :except => :destroy
  resources :ranks
  resources :users, :only => [:index, :create, :update, :edit, :new]
  resources :magazines, :only => [:index, :update]

  devise_for :userauths, :controllers =>{:registrations => "devise_registrations"}, :path_names => { :sign_up => "ah_atamagaaaa_buwawa" }

  match '/series/new(/:id)' => 'series#new', :as => 'new_serie'
  match '/:name/series/:id' => 'series#show', :as => 'serie', :via => :get
  match '/:name/series/:id' => 'series#update', :as => 'serie', :via => :put
  match '/series/:id' => 'series#show'#, :as => 'serie'
  match '/series/:id/update_author' => 'series#update_author', :via => :post
  match '/series/:id/update_magazine' => 'series#update_magazine', :via => :post
  match '/series/:id/update_post' => 'series#update_post', :via => :post
  match '/users/:name' => 'users#show', :as => 'user'
  match '/search' => 'series#search', :as => 'serie_search'
  match '/ranking(/:str)' => 'series#ranking', :as => 'serie_ranking'
  match '/irc' => 'irc#index', :as => 'irc'
  match '/about' => 'home#about', :as => 'about'
  match '/robots' => 'home#robots'
  match '/topics/:id(/((:from)(-:to))(|:top))' => 'topics#show', :as => "topic"
  get '/how_to_use' => 'home#how_to_use', :as => "userauth_root"
  match '/magazines/merge' => 'magazines#merge', :as => 'magarines_merge', :via => :post

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

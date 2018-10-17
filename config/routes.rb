Mantropy::Application.routes.draw do

  resources :magazines_series


  get "home/robots"
  get "irc/index"
  get "home/index"

  resources :browsenodeids

  root :to => 'home#index'
  resources :series, :except => [:new, :show, :update, :destroy]
  resources :posts, :except => :destroy
  resources :topics, :except => [:destroy, :show]
  resources :books, :except => :destroy
  resources :ranks
  resources :users, :only => [:index, :create, :update, :edit, :new]
  resources :magazines, :only => [:index, :update]
  resources :wikis, :only => [:index, :create, :new]
  resources :rankings, :only => [:index, :show, :update, :create]
  resources :site_configs, only: [:create, :update, :destroy]

  devise_for :userauths, :controllers =>{:registrations => "devise_registrations"}
  devise_scope :userauths do
    get '/userauths/sign_out' => 'devise/sessions#destroy'
  end

  get '/series/new(/:id)' => 'series#new', :as => 'new_serie'
  get '/:name/series/:id' => 'series#show', :as => 'serie', :via => :get
  patch '/:name/series/:id' => 'series#update'
  get '/series/:id' => 'series#show'#, :as => 'serie'
  post '/series/:id/update_author' => 'series#update_author'
  post '/series/:id/update_magazine' => 'series#update_magazines_series'
  post '/series/:id/update_post' => 'series#update_post'
  get '/users/:name' => 'users#show'
  get '/search' => 'series#search', :as => 'serie_search'
  get '/ranking(/:str)' => 'series#ranking_now', :as => 'serie_ranking'
  #match '/ranking/:str/name' => 'series#ranking_name'
  get '/irc' => 'irc#index', :as => 'irc'
  get '/robots' => 'home#robots'
  get '/topics/:id(/((:from)(-:to))(/:top))' => 'topics#show'
  post '/magazines/merge' => 'magazines#merge', :as => 'magarines_merge'
  get '/remove_duplications/:ranking_id(/:order_by)' => "series#remove_duplications"
  get '/:name' => 'wikis#show', :as => "wiki"

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

Mantropy::Application.routes.draw do

  resources :magazines_series


  get "home/robots"
  get "irc/index"
  get "home/index"

  resources :browsenodeids

  root :to => 'home#index'
  resources :series, :except => [:new, :show, :update, :destroy]
  resources :users, :only => [:index]
  get '/users/:name' => 'users#show'
  resources :magazines, :only => [:index, :update]
  resources :rankings, :only => [:index, :show, :update, :create]
  resources :wikis, :only => [:show]
  get '/:name' => 'wikis#show', :as => "wiki"

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
  get '/search' => 'series#search', :as => 'serie_search'
  get '/ranking(/:str)' => 'series#ranking_now', :as => 'serie_ranking'
  #match '/ranking/:str/name' => 'series#ranking_name'
  get '/irc' => 'irc#index', :as => 'irc'
  get '/robots' => 'home#robots'
  get '/topics/:id(/((:from)(-:to))(/:top))' => 'topics#show'
  post '/magazines/merge' => 'magazines#merge', :as => 'magarines_merge'
  get '/remove_duplications/:ranking_id(/:order_by)' => "series#remove_duplications"

  namespace :member do
    resources :books, :except => :destroy
    resources :posts, :except => :destroy
    resources :ranks
    resources :topics, :except => [:destroy, :show]
    resources :wikis, :only => [:index, :create, :new]
    resources :users, :only => [:create, :update, :edit, :new]
    resources :site_configs, only: [:create, :update, :destroy]
  end
end

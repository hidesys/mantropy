Mantropy::Application.routes.draw do

  resources :magazines_series


  get "home/robots"
  get "home/index"

  resources :browsenodeids

  # 分離済み
  root :to => 'home#index'
  resources :users, :only => [:index]
  get '/users/:name' => 'users#show', :as => "user"

  get '/:name/series/:id' => 'series#show', :as => 'serie', :via => :get
  resources :series, only: %i[index]
  get '/series/:id' => 'series#show'
  get '/ranking(/:str)' => 'series#ranking_now', :as => 'serie_ranking'

  get '/robots' => 'home#robots'

  # 未整理
  resources :magazines, :only => [:index, :update]
  post '/magazines/merge' => 'magazines#merge', :as => 'magarines_merge'

  resources :rankings, :only => [:index, :show, :update, :create]
  devise_for :userauths, :controllers =>{:registrations => "devise_registrations"}
  devise_scope :userauths do
    get '/userauths/sign_out' => 'devise/sessions#destroy'
  end

  namespace :member do
    resources :books, :except => :destroy
    resources :posts, :except => :destroy
    resources :ranks
    get '/topics/:id(/((:from)(-:to))(/:top))' => 'topics#show'
    resources :topics, :except => [:destroy, :show]
    resources :wikis, :only => [:index, :create, :new]
    resources :users, :only => [:create, :update, :edit, :new]
    resources :site_configs, only: [:create, :update, :destroy]

    resources :series, only: %i[index new create edit update] do
      scope module: :series do
        resource :author, only: :update
        resource :magazine, only: :update
        resource :post, only: :update
      end
    end
    # どこからも呼ばれていないので不要？
    # get '/remove_duplications/:ranking_id(/:order_by)' => "series#remove_duplications"
  end
  get '/:name' => 'wikis#show', :as => "wiki"
end

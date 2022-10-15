Mantropy::Application.routes.draw do
  namespace :member do
    resource to: 'home#index'

    resources :books, except: :destroy
    resources :posts, except: :destroy
    resources :ranks
    get '/topics/:id(/((:from)(-:to))(/:top))' => 'topics#show'
    resources :topics, except: %i[destroy show]
    resources :wikis, only: %i[index create new]
    resources :users, only: %i[create update edit new]
    resources :site_configs, only: %i[index create update destroy]

    resources :series, only: %i[index new create edit update] do
      scope module: :series do
        resource :author, only: :update
        resource :magazine_serie, only: :update
        resource :post, only: :update
      end
    end

    resources :rankings, only: %i[index show update create]
    resources :magazines, only: %i[index update]
    post '/magazines/merge' => 'magazines#merge', :as => 'magarines_merge'
    # どこからも呼ばれていないので不要？
    # get '/remove_duplications/:ranking_id(/:order_by)' => "series#remove_duplications"
  end

  # 分離済み
  get '/robots' => 'home#robots'

  root to: 'home#index'
  resources :users, only: %i[index show]

  get '/:name/series/:id' => 'series#show', :as => 'serie', :via => :get
  resources :series, only: %i[index]
  get '/series/:id' => 'series#show'
  get '/ranking(/:str)' => 'series#ranking_now', :as => 'serie_ranking'

  get '/wikis/:name' => 'wikis#show', :as => 'wiki'

  devise_for :userauths, controllers: { registrations: 'devise_registrations' }
  devise_scope :userauths do
    get '/userauths/sign_out' => 'devise/sessions#destroy'
  end
end

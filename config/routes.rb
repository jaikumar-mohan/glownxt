Glowcon::Application.routes.draw do

  devise_for :users, 
    path: '', path_names: { sign_in: 'signin', sign_up: 'signup', sign_out: 'signout'},
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
      confirmations: "users/confirmations",
      unlocks: "users/unlocks"
    }

  resources :entries, only: [:show, :index]

  get '/archive/:month', to: 'entries#index', as: 'archive_entries'
  get '/category/:category', to: 'entries#index', as: 'category_entries'

  resources :users do
    member do
      get :following, :followers
      get :load_follows
    end
    
    collection do
      get :pitching
      post :final_step
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :email_validation

  resources :companies do
    put :update_pitch
    put :change_logo
    resources :microposts, only: [ :create, :destroy ] do
      get :load, on: :collection
    end
    resources :messages, only: [ :create ]
  end

  resources :microposts, only: [] do
    resources :comments, only: [ :create, :destroy ]
  end

  resources :contacts, only: [:new, :create]

  resources :messages, only: [ :index ] do
    collection do
      get :search
      get :load
      post :mass_sending
    end
  end

  resources :connections, only: [ :index ] do
    collection do
      get :follow
      get :load
    end
  end

  resources :tags, only: [] do
    collection do
      get :autocomplete
    end
  end

  resources :countries, only: [ :index ], controller: :location_autocomplete do
    get :states
  end

  resources :profile, only: [ :update ] do
    member do
      patch :update_pitch
      patch :change_logo
      patch :update_user_data
    end
  end

  root to: 'home#index'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/dashboard', to: 'static_pages#dashboard'
  get '/terms', to: 'static_pages#terms'
  get '/code', to: 'static_pages#code'
  get '/walk', to: 'static_pages#walk'

  get 'static_pages/final_step_design'
  get 'static_pages/create_glows'
  get 'static_pages/make_connections'
  get 'static_pages/private_messages'

  resources :m do
    collection do
      get :connections
      get :welcome
      get :dashboard
      get :home
      get :blog
      get :blog_item
      get :contacts
      get :reset
      get :sign_1
      get :sign_2
      get :sign_3
      get :profile
      get :messages
      get :followers
    end
  end
end

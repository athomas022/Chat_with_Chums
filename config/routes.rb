Rails.application.routes.draw do

  mount ActionCable.server => "/cable"

  devise_for :users, controllers: {
    registrations: 'registrations/registrations',
    sessions: 'sessions'
  }, path: ''
  
  get '/about_us', to: 'about_us#index', as: 'about_us'
  get  '/test', to: 'test#index', as: 'test'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'registrations#new', as: 'new_user_registration_path'
  post '/start_chat_with/:receipient_id', to: 'direct_messages#create'
  # get '/login_or_signup', to: 'sessions#login_or_signup', as: login_or_signup

  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
  end
  resources :chat_rooms, only: [:index, :new, :show, :create, :update, :destroy] do
   resources :messages, only: [:index, :show, :new, :create, :update, :destroy]
  end
  # get 'welcome/index'
  root 'welcome#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

Rails.application.routes.draw do

  mount ActionCable.server => "/cable"

  devise_for :users, skip: [:sessions]
  
  get '/about_us', to: 'about_us#index', as: 'about_us'
  get  '/test', to: 'test#index', as: 'test'
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
  get '/signup', to: 'users#new', as: 'new_user'
  post '/start_chat_with/:recipient_id', to: 'direct_messages#new', as: 'start_chat_with'
  get 'chat_with/:recipient_id', to: 'direct_messages#show', as: 'chat_with'
  # post '/join', to: 'chat_rooms#join', as: 'join_chat_room'
  # delete '/leave', to: 'chat_rooms#leave', as: 'leave_chat_room'

  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
  end
  resources :chat_rooms, only: [:index, :new, :show, :create, :update, :destroy] do
    member do
      post 'join'
      delete 'leave'
    end
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

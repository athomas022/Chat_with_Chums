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
  post 'add_friend/:friend_id', to:'users#add_friends', as: 'add_friend'
  delete 'remove_participant/:user_id', to: 'chat_rooms#remove_participant', as: 'remove_participant'


  resources :users, only: [:index, :show, :create, :edit, :update, :destroy] do
  end
  resources :chat_rooms, only: [:index, :edit, :new, :show, :create, :update, :destroy] do
    member do
      post 'join'
      delete 'leave'
    end
    resources :direct_messages, only: [:show, :new]
    resources :messages, only: [:index, :show, :new, :create, :update, :destroy]
  end
  root 'welcome#index'

  get "up" => "rails/health#show", as: :rails_health_check

  get '*path', to: 'welcome#index', constraints: ->(req) { !req.xhr? && req.format.html? }

end

Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create, :update, :destroy] do
  end
  resources :sessions, only: [:create, :destroy] do
  end
  resources :chat_rooms, only: [:index, :create, :show, :create, :update, :destroy] do
   resources :messages, only: [:index, :show, :create, :update, :destroy]
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

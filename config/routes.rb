Rails.application.routes.draw do
  # Devise custom routes
  devise_for :users,
             path: '/api/v1',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  # Profile routes (custom user endpoint)
  devise_scope :user do
    get '/api/v1/profile', to: 'users/registrations#show'
    put '/api/v1/profile', to: 'users/registrations#update'
  end

  # ActionCable WebSocket endpoint
  mount ActionCable.server => '/cable'
  # root to: proc { [200, {}, ['BanterBox API is alive']] }
  root to: 'home#index' 
  get "/signup", to: "home#index"
  get "/profile", to: "home#index"
  get "/login", to: "home#index"
  get "/chatrooms", to: "home#index"
  get "/chat/:id", to: "home#index"

  # API routes
  namespace :api do
    namespace :v1 do
      resources :chat_rooms, only: [:index, :create, :destroy] do
        resources :messages, only: [:index, :create, :update, :destroy]
      end
    end
  end
end

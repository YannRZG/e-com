Rails.application.routes.draw do
  # Montre les routes OmniAuth
  match "/auth/:provider/callback", to: "sessions#omniauth", via: [ :get, :post ]
  get "/auth/failure", to: "sessions#failure"

  # Autres routes existantes
  root "home#home"
  get "profile/show"
  resource :session
  resources :passwords, param: :token
  resources :users
  resource :profile, only: [ :show ]
end

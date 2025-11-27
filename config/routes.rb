Rails.application.routes.draw do
  # Montre les routes OmniAuth
  match "/auth/:provider/callback", to: "sessions#omniauth", via: [ :get, :post ]
  get "/auth/failure", to: "sessions#failure"

  get "/login", to: "sessions#new"

  # Autres routes existantes
  root "home#home"
  resource :session
  resources :passwords, param: :token
  resources :users
  resource :profile, only: [ :show, :edit, :update, :destroy ] do
    patch :update_password
  end
end

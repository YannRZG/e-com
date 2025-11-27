Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    scope: "email,profile",
    prompt: "select_account",
    provider_ignores_state: false
  }
end
OmniAuth.config.full_host = "http://localhost:3000" # à ajuster selon votre configuration
OmniAuth.config.allowed_request_methods = [ :get, :post ]

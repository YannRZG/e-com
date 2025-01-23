Mailjet.configure do |config|
  config.api_key = ENV["MAILJET_API_KEY"]        # Clé publique
  config.secret_key = ENV["MAILJET_SECRET_KEY"] # Clé secrète
  config.default_from = "yann.rezigui@gmail.com"
end

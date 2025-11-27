class SessionsController < ApplicationController
  # Permet l'accès non authentifié uniquement aux actions new et create
  allow_unauthenticated_access only: %i[new create omniauth]

  # Limitation du nombre de tentatives de connexion
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_session_url, alert: "Try again later."
  }

  # Callback OmniAuth
  def omniauth
    Rails.logger.debug "Session ID: #{session.id}"
    Rails.logger.debug "OmniAuth Params: #{request.env['omniauth.auth']}"

    auth_info = auth
    if auth_info && auth_info[:info] && auth_info[:info][:email]
      user = User.find_or_create_by(email_address: auth_info[:info][:email]) do |u|
        u.name = auth_info[:info][:name]
        u.image_url = auth_info[:info][:image]
        u.provider = auth_info[:provider]
        u.uid = auth_info[:uid]
        # Tu peux générer un mot de passe aléatoire si nécessaire
        u.password = SecureRandom.hex(16) if u.respond_to?(:password=)
      end

      if user
        start_new_session_for(user)   # au lieu de session[:user_id] = user.id
        redirect_to root_path, notice: "Connexion réussie avec Google !"
      else
        redirect_to root_path, alert: "Échec de l'authentification Google."
      end
    else
      redirect_to root_path, alert: "Email non trouvé dans la réponse de Google."
    end
  end

  # Formulaire de connexion classique
  def new
    render :new
  end

  # Connexion classique
  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
    if user
      start_new_session_for(user)   # au lieu de session[:user_id] = user.id
      redirect_to root_path, notice: "Connexion réussie !"
    else
      flash.now[:alert] = "Identifiants incorrects."
      render :new, status: :unprocessable_entity
    end
  end


  # Déconnexion
  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Déconnexion réussie."
  end


  private

  def auth
    request.env["omniauth.auth"]
  end
end

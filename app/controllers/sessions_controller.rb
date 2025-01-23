class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }


  def omniauth
    user = User.find_or_create_by(email: auth[:info][:email]) do |u|
      u.name = auth[:info][:name]
      u.image_url = auth[:info][:image]
      u.provider = auth[:provider]
      u.uid = auth[:uid]
    end

    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "Connexion réussie avec Google !"
    else
      redirect_to root_path, alert: "Échec de l'authentification Google."
    end
  end

  def new
  end

  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
    
    if user
      start_new_session_for(user)
      redirect_to root_path
    else
      flash.now[:alert] = "Identifiants incorrects."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end

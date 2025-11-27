class ProfilesController < ApplicationController
  include Authentication

  before_action :require_authentication

  def show
    @user = Current.user
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    # Vérifie si l'utilisateur veut changer son mot de passe
    if params[:user][:password].present?
      # Vérifie le mot de passe actuel
      unless @user.authenticate(params[:user][:current_password])
        flash.now[:alert] = "Mot de passe actuel incorrect."
        return render :edit, status: :unprocessable_entity
      end

      # Met à jour le mot de passe et les infos de profil
      if @user.update(user_params.merge(password_params))
        redirect_to profile_path, notice: "Profil et mot de passe mis à jour avec succès."
      else
        flash.now[:alert] = "Erreur lors de la mise à jour du profil ou du mot de passe."
        render :edit, status: :unprocessable_entity
      end
    else
      # Mise à jour uniquement des infos de profil
      if @user.update(user_params)
        redirect_to profile_path, notice: "Profil mis à jour avec succès."
      else
        flash.now[:alert] = "Erreur lors de la mise à jour du profil."
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  # Attributs du profil uniquement
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email_address,
      :image_url
    )
  end

  # Attributs du mot de passe uniquement
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

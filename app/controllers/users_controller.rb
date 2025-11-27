class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = Current.user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_now

      # Connexion automatique après inscription 🚀
      start_new_session_for(@user)  # ⚡ utilise la méthode Authentication

      redirect_to root_path, notice: "Inscription réussie. Bienvenue !"
    else
      flash.now[:alert] = "Erreur lors de l'inscription."
      render :new, status: :unprocessable_entity
    end
  end



  def update
    @user = User.find(params[:id])
  end

  def destroy
    @user = current_user
    @user.destroy

    reset_session

    redirect_to root_path, notice: "Votre compte a été supprimé."
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end

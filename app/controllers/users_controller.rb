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
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Inscription réussie."
    else
      flash.now[:alert] = "Erreur lors de l'inscription."
      render :new, status: :unprocessable_entity
    end
  end

  def update 
    @user = User.find(params[:id])
  end

  def destroy
  terminate_session
  redirect_to root_path, notice: "Déconnexion réussie."
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
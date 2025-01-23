class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Modifier votre mot de passe", to: user.email_address
  end
end

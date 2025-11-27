class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  # validates :provider, :uid, presence: true, uniqueness: { scope: :provider }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

    # Méthode d'authentification
    def self.authenticate_by(email_address:, password:)
      user = User.find_by(email_address: email_address)
      user&.authenticate(password)  # Utilise la méthode 'authenticate' de has_secure_password
    end
end

class ProfilesController < ApplicationController
  include Authentication

  before_action :require_authentication

  def show
    @user = Current.user
  end
end

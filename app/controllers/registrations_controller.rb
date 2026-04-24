class RegistrationsController < ApplicationController
  skip_before_action :require_authentication
  skip_before_action :set_current_campaign

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      authenticate(@user)
      redirect_to campaigns_path, notice: "Welcome to The Chronicler!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [ :email_address, :password, :password_confirmation ])
  end
end

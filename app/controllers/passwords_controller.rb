class PasswordsController < ApplicationController
  skip_before_action :require_authentication, only: %i[ new create edit update ]
  skip_before_action :set_current_campaign

  before_action :find_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if (user = User.find_by(email_address: params[:email_address]))
      PasswordsMailer.reset(user).deliver_later
    end
    redirect_to new_session_path, notice: "If that email exists, a reset link is on its way."
  end

  def edit
  end

  def update
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to new_session_path, notice: "Password updated. Please sign in."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_user_by_token
    @user = User.find_by(id: params[:token])
    redirect_to new_password_path, alert: "Invalid or expired reset link." unless @user
  end
end

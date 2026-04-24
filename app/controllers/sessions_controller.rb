class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: %i[ new create ]
  skip_before_action :set_current_campaign

  def new
  end

  def create
    if (user = User.find_by(email_address: params[:email_address])&.authenticate(params[:password]))
      authenticate(user)
      redirect_to campaigns_path
    else
      redirect_to new_session_path, alert: "Invalid email or password."
    end
  end

  def destroy
    unauthenticate
    redirect_to new_session_path
  end
end

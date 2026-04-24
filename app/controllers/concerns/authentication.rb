module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  private

  def authenticate(user)
    Current.session = user.sessions.create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
    cookies.signed.permanent[:session_token] = { value: Current.session.token, httponly: true }
  end

  def unauthenticate
    Current.session&.destroy
    cookies.delete(:session_token)
  end

  def authenticated?
    Current.user.present?
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    if (token = cookies.signed[:session_token])
      Current.session = Session.find_by(token: token)
      Current.user = Current.session&.user
    end
  end

  def request_authentication
    redirect_to new_session_path
  end
end

class ApplicationController < ActionController::Base
  private

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: 'Please log in to continue.'
    end
  end

  def current_user
    if doorkeeper_token
      @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
    elsif session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    nil
  end

  def logged_in?
    !!current_user
  end

  helper_method :current_user, :logged_in?

  def doorkeeper_token
    @doorkeeper_token ||= Doorkeeper::AccessToken.by_token(request.headers['Authorization']&.split(' ')&.last)
  end
end

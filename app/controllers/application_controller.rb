class ApplicationController < ActionController::Base
  private

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: 'Please log in to continue.'
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def logged_in?
    !!current_user
  end

  helper_method :current_user, :logged_in?
end

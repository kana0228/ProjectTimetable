class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  private

  def current_user
    return unless session[:user_id] # session[:user_id] nilなら？
    @current_user ||= User.find(session[:user_id]) #current_userがnilなら、右の値を代入する。
  end

  def logged_in?
    !!session[:user_id] # !nil => true, !!nil => false
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: "ログインしてください"
  end
end

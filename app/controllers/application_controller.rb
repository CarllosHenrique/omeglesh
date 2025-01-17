class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  allow_browser versions: :modern

  helper_method :current_user
  helper_method :user_logged_in?

  def current_user
    @current_user ||= User.find_by_id(session[:current_user_id])
  end

  def user_logged_in?
    current_user.present?
  end

  private

  def authenticate_user!
    redirect_to root_path unless session[:current_user_id].present?
  end
end

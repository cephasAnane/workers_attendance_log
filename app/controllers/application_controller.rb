class ApplicationController < ActionController::Base
  # Pundit for autorization
  include Pundit::Authorization
  
  # Devise: require login for all pages by default
  before_action :authenticate_user!

  # devise: allow custom fields during sign up/update
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # allow these fields during sign up and account update
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :department_id, :profile_photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :department_id, :profile_photo])
  end
end

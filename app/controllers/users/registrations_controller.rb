class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    allowed = [:name, :username, :age, :role]
    devise_parameter_sanitizer.permit(:sign_up, keys: allowed)
    devise_parameter_sanitizer.permit(:account_update, keys: allowed)
  end
end

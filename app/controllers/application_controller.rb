class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username, :age])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :username, :age])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      reports_path
    else
      books_path
    end
  end

  private
  def require_admin
    redirect_to root_path, alert: "Access denied" unless current_user&.admin?
  end

  private

  def require_writer_or_admin
    unless current_user.writer? || current_user.admin?
      redirect_to books_path, alert: "You are not authorized to perform this action."
    end
  end

  def require_owner_or_admin
    unless current_user&.admin? || @post.user == current_user
      redirect_to @post, alert: "Permission denied."
    end
  end

end

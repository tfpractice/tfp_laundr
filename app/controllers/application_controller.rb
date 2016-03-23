class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # include MachineController
  before_action :configure_permitted_parameters, if: :devise_controller?
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_or_guest_user
  
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        #logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :laundry, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :laundry, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :laundry, :password, :password_confirmation, :current_password) }
  end
  private
  def create_guest_user
    u = User.get_guest
    # u = User.create(:username => "guest_#{rand(1000)}", :email => "guest_#{rand(100)}@example.com", :admin => false, :laundry => 0, :guest => true)
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end

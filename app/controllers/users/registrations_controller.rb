class Users::RegistrationsController < Devise::RegistrationsController
  # before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    # super
    if current_user.update(user_params)
      redirect_to edit_user_registration_path, notice: 'User was successfully updated.'

    else
      render :edit

    end
  end

  def reset_coins
    current_user.reset_coins
    redirect_to loads_path

  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << :coins
    devise_parameter_sanitizer.for(:account_update) << :laundry
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
  private
  def user_params
    params.require(:user).permit(:username, :laundry, :coins)
  end
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

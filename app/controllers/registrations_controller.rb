class RegistrationsController < Devise::RegistrationsController
  def update
    return super if @user.has_password?
    prev_unconfirmed_email = @user.unconfirmed_email

    update_params = account_update_params
    update_params.delete :current_password
    if @user.update_without_password(update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(@user, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, @user, :bypass => true
      respond_with @user, :location => after_update_path_for(@user)
    else
      clean_up_passwords @user
      respond_with @user
    end
  end
end

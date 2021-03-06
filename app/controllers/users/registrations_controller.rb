class Users::RegistrationsController < Devise::RegistrationsController

  # Request for user's e-mail to replace auto-generated e-mail
  # when user authenticates via omniauth provider (e.g. Twitter) which doesn't return e-mail
  def edit_email
  end

  def update_email
    @user = User.find(session['devise.new_user_id'])

    if @user && @user.update(email: params[:email])
      redirect_to questions_path
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
    else
      render 'edit_email'
    end
  end
end

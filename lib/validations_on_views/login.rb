require 'validations_on_views/common'

module ValidationsOnViews::Login

  include ValidationsOnViews::Common
  
  private

  def check_email
    @errors = {}
    email = params[:user][:email]

    if @user.blank?
      check_email_registred_or_not(email)
    end

    unless params[:user][:password].present?
      @errors['password'] = "Password is required"
    end
  end

  def check_password
    if params[:user][:password].present?
      @errors['password'] = "Password is incorrect"
    else
      @errors['password'] = "Password is required"
    end
  end

  def unverified_email(account_active = true)
    @errors['email'] = account_active == true ? 'Your email has not been verified' : 'Your account is currently deactivated!'
  end

end
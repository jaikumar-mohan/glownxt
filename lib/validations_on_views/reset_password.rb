require 'validations_on_views/common'

module ValidationsOnViews::ResetPassword
  
  include ValidationsOnViews::Common

  private

  def check_email
    @errors = {}
    email = params[:user][:email]

    if @user.blank?
      check_email_registred_or_not(email)
    end
  end

  def check_password_ops
    @errors = {}

    @password = password_ops[:password]
    @password_confirmation = password_ops[:password_confirmation]

    if @password.present?
      @errors['password'] = "Password too short" if @password.length < 6
    else
      @errors['password'] = "Password is required"
    end
    
    if @password_confirmation.blank?
      @errors['password_confirmation'] = "Verify Password is required" 
    else
      @errors['password_confirmation'] = "Verify Password doesn't match Password" if @password != @password_confirmation
    end
  end  
end
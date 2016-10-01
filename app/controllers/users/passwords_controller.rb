require 'validations_on_views/reset_password'

class Users::PasswordsController < Devise::PasswordsController

  include ValidationsOnViews::ResetPassword
  include ValidationsOnViews::Login

  before_action :authenticate_user!, only: [ :edit, :update ]
  before_action :set_user, only: [ :edit, :update ]
  before_action :find_user_find_by_email, only: [ :create ] 
  before_action :check_email, only: [ :create ]
  before_action :check_password_ops, only: [ :update ] 

  def create
    user = User.where(email: params[:user][:email]).first
    if user.account_active? 
      self.resource = resource_class.send_reset_password_instructions(resource_params)
    else
      unverified_email(user.account_active)
    end
  end

  def update
    if @errors.blank?
      if @user.reset_password_sent_at < 2.hours.ago
        @errors['password'] = "has expired" 
        flash[:notice] = "Password reset has expired."
        @redirect_url = new_user_password_url
      elsif @user.update(password_ops)
        flash[:notice] = "Password has been changed successfully."
        @redirect_url = new_user_session_url
      end
    else
      @errors.each { |k, v| @user.errors[k] = v }
    end
  end

  private

  def set_user
    @user = User.find_by_reset_password_token!(params[:reset_password_token])
  end

  def find_user_find_by_email
    @user = User.find_by_email(params[:user][:email].downcase)
  end

  def password_ops
    params.require(:user).permit(
      :password,
      :password_confirmation,
      :reset_password_token
    )
  end  
end

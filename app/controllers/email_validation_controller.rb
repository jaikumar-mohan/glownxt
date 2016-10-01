require 'validations_on_views/sign_up'

class EmailValidationController < ApplicationController

  include ValidationsOnViews::SignUp

  before_action :set_user, only: [:update]
  before_action :set_user_by_token_or_id, only: [:edit]

  def edit
    if params[:confirmation_token].present? 
      if @user.confirmation_sent_at < 48.hours.ago
        redirect_to new_email_validation_path, alert: "Validation token is rather old, we will send you a new one, just in case."
        return
      else
        @user.confirm! unless @user.confirmed?
      end
    end
  end

  def update
    if !@user.confirmed?
      @redirect_url = new_email_validation_url(alert: "Validation token is rather old, we will send you a new one, just in case.")
    elsif check_email?(params[:user])
      check_user_information
    elsif @user.update(user_params)
      sign_in @user
      @redirect_url = pitching_users_url
    else
      check_user_information
      unregistred_email
    end

    if @errors.present?
      @errors.each { |k, v| @user.errors[k] = v }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_user_by_token_or_id
    if params[:confirmation_token].present?
      @user = User.find_by_confirmation_token!(params[:confirmation_token])
    else
      @user = User.find(params[:id])
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name, 
      :last_name, 
      :email, 
      :password, 
      :password_confirmation, 
      :state, 
      :company_name, 
      :tos, 
      company_attributes: [
        :company_name,
        :company_profile,
        :capabilities_offered_list,
        :capabilities_lookedfor_list
      ]
    )
  end
end

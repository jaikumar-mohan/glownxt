require 'validations_on_views/edit_user_params'

class ProfileController < ApplicationController

  include ValidationsOnViews::EditUserParams

  before_action :authenticate_user!, only:  [ :update, :update_pitch, :update_user_data ]
  before_action :set_company_for_owner, only: [ :update, :update_pitch, :update_user_data ]
  before_action :remove_password_fields_if_blank, only: [ :update_user_data ]

  def update
    @company.update(company_params)
  end

  def update_user_data
    @user = current_user
    if update_params_are_valid?(true)
      @errors.each { |k, v| @user.errors[k] = v }
    else
      @user.update(user_params)
      sign_in(current_user, bypass: true)
    end
  end

  def update_pitch
    @company = current_user.company
    @company.update!(company_params)
  end

  def change_logo
    @company = current_user.company
    @company.update(change_logo_atts)
  end

  private

  def set_company_for_owner
    @company = Company.verified.readonly(false).find(params[:id])
    if @company != current_user.company
      redirect_to root_url
      return
    end
  end  

  def pitch_params
    params.require(:company).permit(
      :company_profile
    )
  end

  def change_logo_atts
    params.require(:company).
      permit(:logo)
  end

  def user_params
    params.require(:user).permit(
      :first_name, 
      :last_name, 
      :email, 
      :password, 
      :password_confirmation
    )
  end

  def company_params
    params.require(:company).permit(
      :logo, 
      :dummy,
      :company_name, 
      :company_profile, 
      :company_mission,
      :company_services, 
      :company_website, 
      :capabilities_offered_list, 
      :capabilities_lookedfor_list,
      :company_certification_list, 
      :products_description,
      addresses_attributes: [
        :tel,
        :street,
        :city,
        :zip,
        :country_id,
        :state_id
      ]
    )
  end

  def remove_password_fields_if_blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
  end
end

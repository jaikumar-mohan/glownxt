require 'validations_on_views/login'

class Users::SessionsController < Devise::SessionsController

  include ValidationsOnViews::Login

  before_action :set_user, only: [ :create ]  
  before_action :check_email, only: [ :create ] 

  def create
    return if @user.blank?
    
    if @user.confirmed? && @user.account_active?
      if @user.valid_password?(params[:user][:password])
        sign_in @user
        
        if session['selected_tag_before_signin'].present?
          @redirect_url = companies_url(by_tags: session['selected_tag_before_signin'], search_by_tags_mode: 'offer_tags')
          session['selected_tag_before_signin'] = nil
        else
          @redirect_url = connections_path
        end
      else
        check_password
      end
    else
      unverified_email(@user.account_active)
      @user.send_confirmation_instructions
    end
  end

  private

  def set_user
    @user = User.find_by_email(params[:user][:email].downcase)
  end  
end

require 'validations_on_views/sign_up'
require 'validations_on_views/edit_user_params'
require 'resolv-replace'

class UsersController < ApplicationController

  include ValidationsOnViews::SignUp
  include ValidationsOnViews::EditUserParams

  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy, :following, :followers, :pitching, :final_step, :load_follows ]
  before_filter :correct_user, only: [:edit, :update]
  before_action :set_user, only: [ :show, :destroy, :following, :followers, :load_follows ]
  before_action :fetch_glows, only: [ :show ]

  def show
  end
  
  def new
    unless signed_in?
      @user = User.new
    else
      flash[:info] = "You're already logged in ..."
      redirect_to user_path(current_user)
    end
  end

  def create
    @user = User.new(user_params)

    if check_email?(params[:user])
      check_sign_up_information
    elsif @user.save
      @redirect_url = edit_email_validation_url(@user)
      #@redirect_url = edit_email_validation_url(@user)
      #redirect_to root_url
    else
      check_sign_up_information
      unregistred_email
    end

    if @errors.present?
      @errors.each { |k, v| @user.errors[k] = v }
    end
  end

  def edit
  end

  def update
    if check_email?(params[:user])
      update_params_are_valid?
      @company = current_user.company
      render 'companies/edit'
    elsif current_user.update(user_params)
        flash[:success] = "Profile updated"
        sign_in current_user
        redirect_to edit_company_path(current_user.company)
    else
      @user = current_user
      update_params_are_valid?(true)
      @company = current_user.company
      render 'companies/edit'
    end
  end

  # def destroy
  #   if current_user?(@user)
  #     flash[:info] = "You cannot delete yourself"
  #     redirect_to users_path
  #   else
  #     @user.destroy
  #     flash[:success] = "User destroyed"
  #     redirect_to users_path
  #   end
  # end

  def registered_user
    redirect_to user_path(current_user) if signed_in?
  end

  def following
    @title = "Companies we found"
    @users = @user.followed_users.page(params[:page]).per(10)
    render 'relationships/show_follow'
  end

  def followers
    @title = "Companies that found us"
    @users = @user.followers.page(params[:page]).per(10)
    render 'relationships/show_follow'
  end

  def load_follows
    if params[:title] == "Companies we found"
      @users = @user.followed_users.page(params[:page]).per(10)
    else
      @users = @user.followers.page(params[:page]).per(10)
    end
  end

  def pitching
    @company = current_user.company
  end

  def final_step
    @company = current_user.company
    @company.update(company_params)
    
    if session['selected_tag_before_signin'].present?
      @redirect_url = companies_url(by_tags: session['selected_tag_before_signin'], search_by_tags_mode: 'offer_tags')
      session['selected_tag_before_signin'] = nil
      return
    else
      @redirect_url = root_url
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user == @user
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def fetch_glows
    microposts = if @user.id == current_user.id
      Micropost.followed(current_user)
    else
      @user.microposts.not_private
    end

    @microposts = microposts.glows.
      includes(:user, :children, to: [ :company ]).
      order('created_at DESC').
      page(params[:page]).per(10)
  end

  def company_params
    params.require(:company).permit(
      :logo, 
      :dummy,  
      :company_certification_list, 
      :company_website, 
      :company_mission,
      :company_services, 
      :products_description, 
      addresses_attributes: [
        :street,
        :zip,
        :city, 
        :country_id,
        :state_id,
        :tel
      ]
    )
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

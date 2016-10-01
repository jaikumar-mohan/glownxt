require 'company_modules/search'

class CompaniesController < ApplicationController

  include CompanyModules::Search

  before_filter :save_selected_category, only: [ :index ]
  before_action :authenticate_user!, only:  [:new, :create, :index, :show, :edit, :update, :update_pitch]

  before_action :set_company, only: [:show]
  before_action :set_company_for_owner, only: [:edit, :update, :destroy]
  before_action :search_by_conditions, only: [ :index ]
  before_action :set_active_tab!, only: [ :index, :show ]
  before_action :fetch_glows, only: [ :show ]

  def index
  end

  def show
    @top_wanted_capabilities = @company.capabilities_offered.
      select("tags.name, tags.capabilities_offered_count").
      order("tags.capabilities_offered_count DESC")
    @top_certifications = @company.company_certification.
      select("tags.name, tags.company_certification_count").
      order("tags.company_certification_count DESC")
  end

  def new
    @company = Company.new
    @company_relationship = @company.build_company_relationship
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      @companyrelationship = @company.build_company_relationship(user_id: current_user.id , company_id: @company.id)
      @companyrelationship.save
      redirect_to root_url, :notice => "Congratulations, your company is now created and associated with you."
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @company.update(company_params)
  end

  def update_pitch
    @company = current_user.company
    @company.update!(company_params)
  end

  def change_logo
    @company = current_user.company
    @company.update(change_logo_atts)
  end

  def destroy
  end

  private

  def fetch_glows
    microposts = if @company.id == current_user.company.id
      Micropost.followed(current_user)
    else
      @company.user.microposts.not_private
    end

    @microposts = microposts.glows.
      includes(:user, :children, to: [ :company ]).
      page(params[:page]).per(10)
  end

  def set_company
    @company = Company.verified.find(params[:id])
  end  

  def set_company_for_owner
    @company = Company.verified.readonly(false).find(params[:id])
    if @company != current_user.company
      redirect_to root_url
      return
    end
  end  

  def save_selected_category
    if !user_signed_in? && params[:by_tags].present?
      session['selected_tag_before_signin'] = params[:by_tags]
    end
  end

  def set_active_tab!
    @active_tab = params[:id].present? ? 'dashboard' : 'companies'
  end

  def pitch_params
    params.require(:company).permit(
      :company_profile
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

  def change_logo_atts
    params.require(:company).
      permit(:logo)
  end  
end

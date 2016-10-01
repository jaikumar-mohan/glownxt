class ConnectionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_active_tab!, only: [ :index ]
  before_action :set_company, only: [:index]
  before_action :fetch_glows, only: [ :index, :load, :follow]
  before_action :set_marketing_intelligence, only: [ :index ]

  def index
    @top_wanted_capabilities = @company.top_capabilities_wanted_right_now(true)
    @top_needed_capabilities = @company.top_capabilities_needed_right_now(true)

    @top_wanted_capabilities_not_glow = @company.top_capabilities_wanted_right_now(false)
    @top_needed_capabilities_not_glow = @company.top_capabilities_needed_right_now(false)
  end

  def load
    render layout: false
  end  

  def follow

  end

  private

  def fetch_glows
    if params[:checkbox1].present?
      @checkbox1 = "#{params[:checkbox1]}"
      @checkbox2 = "#{params[:checkbox2]}"
    else
      @checkbox1 = "checked"
      @checkbox2 = "checked"
    end
    @microposts = Micropost.follows(current_user, @checkbox1, @checkbox2).
      glows.includes(:user, :children, to: [ :company ]).
      page(params[:page]).per(10)
  end

  def set_active_tab!
    @active_tab = 'connections'
  end

  def set_company
    @company = current_user.company
  end

  def glowing_tags
    select { |tag_block| tag_block[1] > 0 }
  end

  def not_glowing_tags
    select { |tag_block| tag_block[1] == 0 }
  end

  def set_marketing_intelligence
    @companies_looking_for_capabilities_you_offer =  @company.companies_with_capabilities('capabilities_lookedfor')
    @most_sought_capability_tou_offer = @company.most_popular_capability('capabilities_lookedfor')
    @companies_looking_for_capabilities_you_offer_in_same_city = @company.companies_with_capabilities_in_same_city('capabilities_lookedfor')

    @companies_offer_capabilities_you_looking_for = @company.companies_with_capabilities('capabilities_offered')
    @most_offered_capability_that_you_looking_for = @company.most_popular_capability('capabilities_offered')
    @companies_offer_capabilities_you_looking_for_in_same_city = @company.companies_with_capabilities_in_same_city('capabilities_offered') 
  end
end

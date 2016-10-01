require 'company_modules/search'

class MessagesController < ApplicationController

  include CompanyModules::Search

  before_action :authenticate_user!
  before_action :set_active_tab!, only: [ :index ]
  before_action :search_by_conditions, only: [ :index, :search, :load ]
  before_action :set_company, only: [ :create ]

  def index
  end

  def create
    if params[:micropost][:content].present?
      @message = current_user.microposts.create!(
        message_params.merge!(
          to: @company.user,
          :private => true
        )
      )
    end
  end

  def mass_sending
    @company_ids = params[:recepients].split(',') if params[:recepients].present?
    @message = message_params[:content] if message_params.present?

    if @company_ids.present? && @company_ids.count < 6 && @message.present?
      @company_ids.each do |company_id|
        company = Company.find(company_id)

        current_user.microposts.create!(
          message_params.merge!(
            to: company.user,
            :private => true
          )
        )
      end
    end
  end

  def load
  end

  def search
  end

  private

  def set_active_tab!
    @active_tab = 'messages'
  end

  def set_company
    @company = Company.verified.find(params[:company_id])
  end  

  def message_params
    params.require(:micropost).permit(:company_id, :user_id, :content)
  end
end

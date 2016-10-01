class MicropostsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_company, only: [ :create, :load ]
  before_action :check_permissions, only: [ :create ]
  before_action :fetch_microposts, only: [ :load ]
  before_action :set_micropost, only: [:destroy]

  def create
    if params[:micropost][:content].present?
      @micropost = current_user.microposts.create!(micropost_params)
    end
  end

  def destroy
    @micropost.destroy
  end

  def load
    render layout: false
  end

  private

  def set_micropost
    @micropost = current_user.microposts.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def check_permissions
    if @company.id != current_user.company.id
      render nothing: true
      return
    end
  end

  def fetch_microposts
    microposts = if @company.id == current_user.company.id
      Micropost.followed(current_user)
    else
      @company.user.microposts
    end

    @microposts = microposts.glows.
      includes(:user, :children, to: [ :company ]).
      order('created_at DESC').
      page(params[:page]).per(10)
  end

  def micropost_params
    params.require(:micropost).permit(:company_id, :user_id, :content)
  end
end
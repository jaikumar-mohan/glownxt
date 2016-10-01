class LocationAutocompleteController < ApplicationController

  before_action :set_country, only: [ :states ]
  before_action :query_ops, only: [ :index, :states ]

  respond_to :json

  def index
    @countries = Country.by_name(query_ops).limit(10)
    render json: @countries, root: false
  end

  def states
    @states = @country.states.by_name(query_ops).limit(10)
    render json: @states, root: false    
  end

  private

  def query_ops
    params.require(:term)
  end

  def set_country
    @country = Country.find_by_id(params[:country_id])
  end
end
class TagsController < ApplicationController

  before_action :set_tags

  def autocomplete
    render json: @tags, root: false 
  end

  private

  def set_tags
    @tags = ActsAsTaggableOn::Tag.autocomplete_data(params[:q], params[:certificates])
  end
end
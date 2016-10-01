class EntriesController < ApplicationController

  before_action :set_entry, only: [:show]

  def index
    @active_tab = 'blog'
    src = Entry
    src = Entry.month(params[:month].to_i) if params[:month].present?
    src = src.tagged_with(params[:category]) if params[:category].present?

    @dates = src.dates
    @entries = src.page(params[:page]).per(7)
    @categories = Entry.tag_counts
  end

  def show
    @previous = Entry.where('id < ?', @entry.id).limit(10)
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end  
  
  def entry_params
    params.require(:entry).permit(:brief, :body, :title, :tag_list)
  end
end

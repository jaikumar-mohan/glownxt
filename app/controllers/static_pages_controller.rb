class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @company = current_user.company
      render template: 'static_pages/home_for_signed'
    else
      @active_tab = 'home'
      @tags = ActsAsTaggableOn::Tag.joins(:taggings).
        select("tags.name, tags.capabilities_offered_count").distinct.
        where('taggings.context = ?', 'capabilities_offered').
        order('capabilities_offered_count ASC').
        limit(30)

      render template: 'static_pages/home_for_unsigned'
    end
  end

  def dashboard
    return redirect_to signin_path unless signed_in?

    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.page(params[:page])

    @active_tab = 'dashboard'
  end

  def help
    @active_tab = 'help'
  end

  def about
    @active_tab = 'about'
  end

  def contact
    @active_tab = 'contact'
  end

  def final_step_design
    render layout: 'separate_header'
  end

  def create_glows
  end

  def make_connections
  end

  def private_messages
  end

  def terms
  end

  def code
  end
end

class HomeController < ApplicationController

  def index
    if user_signed_in?
      @company = current_user.company
      render template: 'home/home_for_signed'
    else
      @active_tab = 'home'
      @tags = ActsAsTaggableOn::Tag.joins(:taggings).
        select("tags.name, tags.capabilities_offered_count").distinct.
        where('taggings.context = ?', 'capabilities_offered').
        order('capabilities_offered_count ASC').
        limit(30)

      render template: 'home/home_for_unsigned'
    end
  end

end

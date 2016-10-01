class MController < ApplicationController
  
  def connections

  end

  def welcome

  end

  def dashboard
    @top_wanted_capabilities = Company.last.capabilities_offered
  end

  def home
    @top_wanted_capabilities = Company.last.capabilities_offered
  end

  def blog

  end

  def blog_item

  end

  def contacts

  end

  def reset

  end

  def sign_1

  end

  def sign_2

  end

  def sign_3

  end

  def profile

  end

  def followers

  end

  def messages
    possible_queries = %w{name offer_tags looked_tags city country}
    @companies = Company.verified.not_in(current_user.company)

    possible_queries.each do |query|
      if params["by_#{query}".to_sym].present?
        @companies = @companies.send("by_#{query}", params["by_#{query}".to_sym])
      end
    end
    @companies=@companies.page(params[:page]).per(10)
  end
end
class RelationshipsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [ :create ]
  before_action :set_followed_user, only: [ :destroy ]  

  def create
    current_user.follow!(@user)
  end

  def destroy
    current_user.unfollow!(@user)
  end

  private

  def set_user
    @user = User.find(relationship_params[:followed_id])
  end

  def set_followed_user
    @user = Relationship.find(params[:id]).followed
  end

  def relationship_params
    params.require(:relationship).permit(:followed_id)
  end
end
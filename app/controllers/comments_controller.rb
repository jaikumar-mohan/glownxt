class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_micropost, only: [:create]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @micropost.children.create(
      comment_params.merge!(user: current_user)
    )
  end

  def destroy
    @comment.destroy
    render nothing: true
  end

  private

  def set_micropost
    @micropost = Micropost.find(params[:micropost_id])    
  end

  def set_comment
    @comment = current_user.microposts.comments.find(params[:id])
  end    

  def comment_params
    params.require(:micropost).permit(:content, :micropost_id, :user_id, :user)
  end
end

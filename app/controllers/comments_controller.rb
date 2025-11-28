class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: "Comment added."
    else
      redirect_to @commentable, alert: "Comment can't be empty."
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
  end

  def update
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable

    if @comment.update(comment_params)
      redirect_to @commentable, notice: "Comment updated"
    else
      render :edit
    end
  end


  def destroy
    @comment.destroy
    redirect_to @commentable, notice: "Comment deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])
    else
      # fallback or raise
      raise ActionController::RoutingError, "Commentable not found"
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def authorize_user!
    redirect_to @commentable, alert: "Not authorized." unless @comment.user == current_user
  end
end

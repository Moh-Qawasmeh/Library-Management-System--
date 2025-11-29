class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_owner_or_admin, only: [:new, :edit, :update, :destroy]

  def index
    @query = params[:query]

    @posts = Post.includes(:user)
                 .order(created_at: :desc)

    if @query.present?
      @posts = @posts.where("title ILIKE ? OR content ILIKE ?", "%#{@query}%", "%#{@query}%")
    end

    @posts = @posts.paginate(page: params[:page], per_page: 25)
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, alert: "Post deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end



  def post_params
    params.require(:post).permit(:title, :content, :published)
  end
end

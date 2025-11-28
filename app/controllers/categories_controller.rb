class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category
                    .left_joins(:books)
                    .select("categories.*, COUNT(books.id) AS books_count")
                    .group("categories.id")
                    .order("books_count DESC, categories.name ASC")
  end

  def show
    @books = @category.books.includes(:author)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to category_path(@category), notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.books.any?
      redirect_to @category, alert: "You cannot delete this category because it has books."
    else
      @category.destroy
      redirect_to categories_path, notice: "Category deleted successfully."
    end
  end


  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :code, :description)
  end
end

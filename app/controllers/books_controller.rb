class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_writer_or_admin, only: [:new, :create, :edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @books = Book.includes(:author, :category, :tags, :comments).references(:author, :category)

    if params[:search].present?
      q = "%#{params[:search].downcase}%"
      @books = @books.where("LOWER(books.title) LIKE ? OR LOWER(books.isbn) LIKE ?", q, q)
    end

    if params[:author_id].present?
      @books = @books.where(author_id: params[:author_id])
    end

    if params[:category_id].present?
      @books = @books.where(category_id: params[:category_id])
    end

    @books = @books.order(created_at: :desc).paginate(page: params[:page], per_page: 25)

    @authors = Author.order(:name)
    @categories = Category.order(:name)

    respond_to do |format|
      format.html
      format.csv { send_data @books.to_csv, filename: "books-#{Date.today}.csv" }
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user if user_signed_in?

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.includes(:author, :category, :tags, :comments).find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      :title,
      :isbn,
      :description,
      :published_date,
      :page_count,
      :author_id,
      :category_id,
      :tag_names,
      tag_ids: []
    )
  end
end

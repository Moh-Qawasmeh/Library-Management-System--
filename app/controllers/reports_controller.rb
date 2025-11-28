class ReportsController < ApplicationController
  before_action :require_admin

  def index
    @report_type = params[:report_type]
    @category_id = params[:category_id]

    case @report_type
    when "books_count_by_category"
      @categories = Category
                      .left_joins(:books)
                      .group(:id)
                      .select("categories.*, COUNT(books.id) AS books_count")
                      .order("books_count DESC")

    when "books_by_category"
      @categories = Category.order(:name)

      if @category_id.present?
        @books = Book.includes(:author, :category)
                     .where(category_id: @category_id)
                     .order(:title)
      end

    when "books_with_comment_count"
      @books = Book
                 .left_joins(:comments)
                 .select("books.*, COUNT(comments.id) AS comments_count")
                 .group(:id)
                 .order("comments_count DESC")

    when "authors_with_most_comments"
      @authors =
        Author
          .left_joins(books: :comments)
          .group(:id)
          .select("authors.*, COUNT(comments.id) AS comments_count")
          .order("comments_count DESC")
          .limit(10)
    end
  end

end

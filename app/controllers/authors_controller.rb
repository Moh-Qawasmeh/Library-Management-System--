class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show edit update destroy]
  before_action :require_admin, except: %i[index show]

  def index
    @authors =
      Author
        .includes(:books)
        .order(:name)
        .paginate(page: params[:page], per_page: 25)
  end

  def show
    @books = @author
               .books
               .includes(:comments)
               .order(created_at: :desc)
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to @author, notice: "Author created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: "Author updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_path, notice: "Author deleted."
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio, :birth_date, :email, :phone_number)
  end

end

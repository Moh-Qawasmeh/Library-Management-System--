json.extract! book, :id, :title, :isbn, :description, :published_date, :page_count, :author_id, :category_id, :created_at, :updated_at
json.url book_url(book, format: :json)

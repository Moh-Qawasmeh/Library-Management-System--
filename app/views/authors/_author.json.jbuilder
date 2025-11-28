json.extract! author, :id, :name, :bio, :birth_date, :email, :phone_number, :created_at, :updated_at
json.url author_url(author, format: :json)

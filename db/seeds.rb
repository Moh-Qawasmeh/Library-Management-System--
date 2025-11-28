puts "Seeding database..."

# -----------------------------
# USERS
# -----------------------------
admin = User.create!(
  name: "Admin",
  username: "admin",
  age: 30,
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: :admin
)

writers = [
  User.create!(
    name: "Writer One",
    username: "writer1",
    age: 25,
    email: "writer1@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :writer
  ),
  User.create!(
    name: "Writer Two",
    username: "writer2",
    age: 27,
    email: "writer2@example.com",
    password: "password123",
    password_confirmation: "password123",
    role: :writer
  )
]

puts "Users created."

# -----------------------------
# AUTHORS (5)
# -----------------------------
authors = 5.times.map do
  Author.create!(
    name: Faker::Book.author,
    bio: Faker::Lorem.paragraph(sentence_count: 4),
    email: Faker::Internet.email,
    birth_date: Faker::Date.birthday(min_age: 20, max_age: 80),
    phone_number: Faker::PhoneNumber.cell_phone_in_e164
  )
end


puts "Authors created."

# -----------------------------
# CATEGORIES (5)
# -----------------------------
categories = 5.times.map do
  Category.create!(
    name: Faker::Book.genre,
    description: Faker::Lorem.sentence(word_count: 6),
    code: ("A".."Z").to_a.sample(3).join  # 3 random uppercase letters
  )
end

puts "Categories created."

# -----------------------------
# TAGS (8)
# -----------------------------
tags = 8.times.map do
  Tag.create!(name: Faker::Book.genre)
end

puts "Tags created."

# -----------------------------
# BOOKS (20) — each with 2–3 tags
# -----------------------------
books = 20.times.map do
  book = Book.create!(
    title: Faker::Book.title,
    isbn: Faker::Number.number(digits: 10),
    description: Faker::Lorem.paragraph(sentence_count: 3),
    published_date: Faker::Date.between(from: 5.years.ago, to: Date.today),
    page_count: rand(150..600),
    author: authors.sample,
    category: categories.sample
  )

  # Assign 2–3 random tags
  book.tags << tags.sample(rand(2..3))

  book
end

puts "Books created with tags."

# -----------------------------
# POSTS (10)
# -----------------------------
posts = 10.times.map do
  Post.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    content: Faker::Lorem.paragraph(sentence_count: 5),
    published: [true, false].sample,
    user: (writers + [admin]).sample
  )
end

puts "Posts created."

# -----------------------------
# COMMENTS (30) — mixed bo

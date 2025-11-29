require "faker"

puts "👤 Creating Users..."
users = 10.times.map do
  User.create!(
    name: Faker::Name.name,
    username: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password123"
  )
end

puts "🧑‍🏫 Creating Authors..."
authors = 10.times.map do
  Author.create!(
    name: Faker::Book.author,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    birth_date: Faker::Date.birthday(min_age: 25, max_age: 90),
    email: Faker::Internet.unique.email,
    phone_number: Faker::PhoneNumber.unique.cell_phone_in_e164
  )
end

puts "📚 Creating Categories..."
categories = 15.times.map do
  Category.create!(
    name: Faker::Book.unique.genre + " #{rand(1000)}",
    description: Faker::Lorem.sentence,
    code: Faker::Alphanumeric.unique.alpha(number: 3).upcase
  )
end

puts "🏷️ Creating Tags..."
tags = 10.times.map do
  Tag.create!(
    name: Faker::Lorem.unique.word.capitalize
  )
end

puts "📘 Creating Books..."
books = 40.times.map do
  Book.create!(
    title: Faker::Book.title,
    isbn: Faker::Number.number(digits: 13),
    description: Faker::Lorem.paragraph(sentence_count: 5),
    published_date: Faker::Date.between(from: "1900-01-01", to: Date.today),
    page_count: rand(50..1000),
    author: authors.sample,
    category: categories.sample
  )
end

puts "🔗 Assigning Tags to Books..."
books.each do |book|
  rand(1..4).times do
    BookTag.create!(
      book: book,
      tag: tags.sample
    )
  end
end

puts "📝 Creating Posts..."
posts = 30.times.map do
  Post.create!(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraph_by_chars(number: rand(150..600)),
    published: [true, false].sample,
    user: users.sample
  )
end

puts "💬 Adding Comments to Books and Posts..."

# comments on books
75.times do
  Comment.create!(
    content: Faker::Lorem.sentence(word_count: rand(4..12)),
    user: users.sample,
    commentable: books.sample
  )
end

# comments on posts
75.times do
  Comment.create!(
    content: Faker::Lorem.sentence(word_count: rand(4..12)),
    user: users.sample,
    commentable: posts.sample
  )
end

puts "🎉 DONE! Massive seed data created successfully!"

require "csv"
class Book < ApplicationRecord
  belongs_to :author
  belongs_to :category
  belongs_to :user, optional: true

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  attr_accessor :tag_names

  validates :title, presence: true

  validates :isbn,
            presence: true,
            uniqueness: true,
            length: { minimum: 10 }

  validates :page_count,
            numericality: { only_integer: true, greater_than: 0 }

  validates :author, presence: true
  validates :category, presence: true

  before_validation :normalize_isbn
  after_save :assign_tags_from_tag_names

  def comments_count
    comments.size
  end

  private

  def normalize_isbn
    self.isbn = isbn.to_s.strip if isbn
  end

  def assign_tags_from_tag_names
    return if tag_names.blank?

    names = tag_names.split(",").map { |n| n.strip }.reject(&:blank?).uniq

    found_tags = names.map { |name| Tag.find_or_create_by(name: name) }
    self.tags = found_tags
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Title", "ISBN", "Author", "Category", "Page Count", "Published Date"]

      all.find_each do |book|
        csv << [
          book.id,
          book.title,
          book.isbn,
          book.author&.name,
          book.category&.name,
          book.page_count,
          book.published_date
        ]
      end
     end
    end
end

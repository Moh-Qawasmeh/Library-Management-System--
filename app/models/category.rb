class Category < ApplicationRecord
  has_many :books, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :code,
            presence: true,
            uniqueness: true,
            format: { with: /\A[A-Z]{3}\z/, message: "must be exactly 3 uppercase letters" }
  validates :description, allow_blank: true, length: { maximum: 1000 }
end

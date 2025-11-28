class Author < ApplicationRecord
  has_many :books, dependent: :destroy


  validates :name, presence: true

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone_number, presence: true
end

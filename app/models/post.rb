class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true

  validates :content,
            presence: true,
            length: { minimum: 10 }

  validates :user, presence: true
  scope :published, -> { where(published: true) }
end

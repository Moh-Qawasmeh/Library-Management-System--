class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content,
            presence: true,
            length: { minimum: 2 }

  validates :user, presence: true
  validates :commentable, presence: true
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: { admin: 0, writer: 1 }

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :age,
            numericality: { only_integer: true, allow_nil: true }

  validates :name,
            presence: true
end

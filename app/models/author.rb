class Author < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :authorideas
  has_many :books, through: :authors_books
  has_many :authors_books
  has_many :series, through: :authors_series
  has_many :authors_series
end

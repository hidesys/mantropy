class Author < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :authorideas # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :books, through: :authors_books
  has_many :authors_books # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :series, through: :authors_series
  has_many :authors_series # rubocop:disable Rails/HasManyOrHasOneDependent
end

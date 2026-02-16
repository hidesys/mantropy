class Book < ApplicationRecord
  validates :name, presence: true
  has_many :bookaffairs # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :topics # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :bookreals # rubocop:disable Rails/HasManyOrHasOneDependent
  has_and_belongs_to_many :series # rubocop:disable Rails/HasAndBelongsToMany
  has_many :authors_books # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :authors, through: :authors_books
  has_one :manazines # rubocop:disable Rails/HasManyOrHasOneDependent
  has_and_belongs_to_many :browsenodeids # rubocop:disable Rails/HasAndBelongsToMany
end

class Book < ActiveRecord::Base
  validates :name, presence: true
  has_many :bookaffairs
  has_many :topics
  has_many :bookreals
  has_and_belongs_to_many :series
  has_many :authors_books
  has_many :authors, through: :authors_books
  has_one :manazines
  has_and_belongs_to_many :browsenodeids
end

class Magazine < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :magazines_series # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :series, through: :magazines_series
  belongs_to :book, optional: true
end

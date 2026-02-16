class Rank < ApplicationRecord
  validates :score,
            presence: true,
            unless: :rank?
  validates :rank,
            presence: true,
            unless: :score?

  belongs_to :ranking
  belongs_to :user
  belongs_to :serie
end

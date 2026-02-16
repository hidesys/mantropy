class Ranking < ApplicationRecord
  validates :name, presence: true
  has_many :ranks, dependent: :destroy
end

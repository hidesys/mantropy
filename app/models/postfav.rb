class Postfav < ApplicationRecord
  validates :score, presence: true
  belongs_to :post
  belongs_to :user
end

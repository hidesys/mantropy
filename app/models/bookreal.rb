class Bookreal < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :transfers
end

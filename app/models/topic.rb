class Topic < ApplicationRecord
  has_one :book
  has_many :posts
end

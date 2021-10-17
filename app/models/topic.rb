class Topic < ActiveRecord::Base
  has_one :book
  has_many :posts
end

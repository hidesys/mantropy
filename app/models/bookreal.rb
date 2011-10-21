class Bookreal < ActiveRecord::Base
	validates :book_id, :presence => true
	validates :user_id, :presence => true
	
  belongs_to :book
  belongs_to :user
  has_many :transfers
end

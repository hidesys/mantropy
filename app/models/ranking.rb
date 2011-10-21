class Ranking < ActiveRecord::Base
	validates :name, :presence => true
	has_many :ranks
end

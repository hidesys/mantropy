class Magazine < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
	has_and_belongs_to_many :series
        belongs_to :book
end

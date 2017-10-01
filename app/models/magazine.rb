class Magazine < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  has_many :series, :through => :magazines_series
  has_many :magazines_series
  belongs_to :book, optional: true
end

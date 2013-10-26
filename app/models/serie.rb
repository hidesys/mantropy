class Serie < ActiveRecord::Base
  validates :name, :presence => true
  has_many :ranks
  has_many :authors_series
  has_many :authors, :through => :authors_series
  has_and_belongs_to_many :books
  has_many :magazines_series
  has_many :magazines, :through => :magazines_series
  has_and_belongs_to_many :tags
  belongs_to :post
  belongs_to :topic
end

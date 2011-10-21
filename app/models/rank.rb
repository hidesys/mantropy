class Rank < ActiveRecord::Base
  validates :ranking_id, :presence => true
  validates :user_id, :presence => true
  validates :serie_id, :presence => true
  validates :score,
    :presence => true,
    :unless => :rank?
  validates :rank,
    :presence => true,
    :unless => :score?
  
  belongs_to :ranking
  belongs_to :user
  belongs_to :serie
end

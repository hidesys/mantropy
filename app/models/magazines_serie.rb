class MagazinesSerie < ActiveRecord::Base
  belongs_to :magazine
  belongs_to :serie
  attr_accessible :placed, :magazine_id, :serie_id, :magazine, :serie
end

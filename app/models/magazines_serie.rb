class MagazinesSerie < ActiveRecord::Base
  belongs_to :magazine
  belongs_to :serie
end

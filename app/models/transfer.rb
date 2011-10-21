class Transfer < ActiveRecord::Base
	validates :bookreal_id, :presence => true
  belongs_to :bookreal
  belongs_to :user
end

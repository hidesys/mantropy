class Authoridea < ActiveRecord::Base
  validates :author_id, presence: true
  validates :idea, presence: true, uniqueness: true
  belongs_to :author
end

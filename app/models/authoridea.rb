class Authoridea < ApplicationRecord
  validates :idea, presence: true, uniqueness: true
  belongs_to :author
end

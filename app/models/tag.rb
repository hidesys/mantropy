class Tag < ApplicationRecord
  validates :name, presence: true
  has_and_belongs_to_many :series # rubocop:disable Rails/HasAndBelongsToMany
end

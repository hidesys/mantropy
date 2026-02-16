class Browsenodeid < ApplicationRecord
  validates :node, presence: true
  validates :name, presence: true
  has_and_belongs_to_many :books # rubocop:disable Rails/HasAndBelongsToMany
end

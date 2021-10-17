class Browsenodeid < ActiveRecord::Base
  validates :node, presence: true
  validates :name, presence: true
  has_and_belongs_to_many :books
end

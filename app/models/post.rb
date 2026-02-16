class Post < ApplicationRecord
  validates :content, presence: true
  validates :name,
            presence: true,
            unless: :user_id?
  validates :user_id,
            unless: :name?
  belongs_to :topic
  belongs_to :user
  has_many :postfavs # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :replies # rubocop:disable Rails/HasManyOrHasOneDependent
  has_one :serie # rubocop:disable Rails/HasManyOrHasOneDependent
end

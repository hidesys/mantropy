class Post < ApplicationRecord
  belongs_to :topic
  belongs_to :user, optional: true

  validates :content, presence: true
  validates :name, presence: true, unless: :user_id?
  validates :user, presence: true, unless: :name?
  has_many :postfavs # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :replies # rubocop:disable Rails/HasManyOrHasOneDependent
  has_one :serie # rubocop:disable Rails/HasManyOrHasOneDependent
end

class Postfav < ActiveRecord::Base
  validates :post_id, presence: true
  validates :user_id, presence: true
  validates :score, presence: true
  belongs_to :post
  belongs_to :user
end

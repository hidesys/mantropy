class Post < ActiveRecord::Base
  validates :content, :presence => true
  validates :topic_id, :presence => true
  validates :name,
    :presence => true,
    :unless => :user_id?
  validates :user_id,
    :presence => true,
    :unless => :name?
  belongs_to :topic
  belongs_to :user
  has_many :postfavs
  has_many :replies
  has_one :serie
end

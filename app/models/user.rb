# encoding: UTF-8
class User < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
        validates :realname, :presence => true
        validates :pcmail, :presence => true
        validates :mbmail, :presence => true
        validates :joined, :presence => true
        validates :entered, :presence => true
  validate :name_valid?

	has_many :series
	has_many :posts
	has_many :postfavs
	has_many :replies
	has_many :ranks
	has_many :transfers
	has_many :bookreals
	has_many :userauths
        has_many :wikis
  private
  def name_valid?
    errors.add(:name, '. # % : \ / を含む文字列は、ユーザー名には使えません') if name =~ /[\.\#\%\:\/\\]/
  end
end

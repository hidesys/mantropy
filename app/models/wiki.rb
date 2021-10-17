class Wiki < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validate :name_valid?

  private

  def name_valid?
    errors.add(:name, 'ページ名には、小文字半角英数字とアンダーバーのみ使えます') unless name =~ /^[0-9a-z_]+$/
  end
end

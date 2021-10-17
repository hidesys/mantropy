class Member::MagazinesController < Member::Base
  def index
    @magazines = Magazine.order(:publisher, :name)
  end
end

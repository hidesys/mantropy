class BooksBrowsenodeid < ActiveRecord::Base
  belongs_to :book
  belongs_to :browsenodeid
end

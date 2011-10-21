class AuthorsSerie < ActiveRecord::Base
  belongs_to :author
  belongs_to :serie
end

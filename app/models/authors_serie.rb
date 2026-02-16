class AuthorsSerie < ApplicationRecord
  belongs_to :author
  belongs_to :serie
end

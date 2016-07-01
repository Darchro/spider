class Article < ApplicationRecord
  belongs_to :category
  belongs_to :account
end

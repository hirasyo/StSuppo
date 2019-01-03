class Monster < ApplicationRecord
  has_many :histories
  has_many :users
end

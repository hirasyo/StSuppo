class User < ApplicationRecord
  has_many :histories
  has_many :monsters, through: :histories

  validates :name, presence: true, uniqueness: true

end

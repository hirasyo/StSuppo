class History < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :monster, optional: true
end

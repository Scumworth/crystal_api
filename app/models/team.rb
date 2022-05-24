class Team < ApplicationRecord
  has_many :profiles
  validates :name, presence: true, uniqueness: true
end

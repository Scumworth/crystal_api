class Profile < ApplicationRecord
  belongs_to :team
  validates :first_name, :last_name, :email, :team_id, :presence => true
end

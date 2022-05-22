class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :team_id
end

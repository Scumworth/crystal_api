class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :profiles
end

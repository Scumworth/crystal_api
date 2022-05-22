class ProfileSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name
  attribute :id, if: :is_current_user?
  attribute :email, if: :is_current_user?
  attribute :team_id, if: :is_current_user?

  def is_current_user?
    current_user ? true : false
  end
end

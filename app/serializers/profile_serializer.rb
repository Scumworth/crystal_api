class ProfileSerializer < ActiveModel::Serializer
  attribute :id, if: :is_current_user?
  attribute :email, if: :is_current_user?
  belongs_to :team, if: :is_current_user?
  attributes :first_name, :last_name

  def is_current_user?
    current_user ? true : false
  end
end

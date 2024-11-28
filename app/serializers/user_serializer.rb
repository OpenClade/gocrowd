class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role

  def role
    object.role || "user"
  end
end
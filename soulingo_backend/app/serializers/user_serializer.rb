class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role, :avatar_url
end


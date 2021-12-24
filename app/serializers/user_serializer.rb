class UserSerializer
  include JSONAPI::Serializer

  set_id { 0 }
  attributes :email, :first_name, :last_name, :phone
end

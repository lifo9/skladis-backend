class UserSerializer
  include JSONAPI::Serializer

  attributes :email, :first_name, :last_name, :phone

  has_many :roles

  attribute :active, if: Proc.new { |_, params|
    params && params[:admin] == true
  }
end
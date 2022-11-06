class UserSerializer < ApiSerializer

  attributes :email, :first_name, :last_name, :phone

  has_many :roles

  attribute :active, if: Proc.new { |_, params|
    params && params[:admin] == true
  }

  attribute :avatar do |user|
    attachment_url(user.avatar.variant(:thumb)) if user.avatar.attached?
  end
end
class ContactSerializer < ApiSerializer

  attributes *Contact::PERMITTED_PARAMS

  attribute :avatar do |user|
    attachment_url(user.avatar.variant(:thumb)) if user.avatar.attached?
  end
end

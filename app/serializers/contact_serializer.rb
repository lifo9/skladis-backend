class ContactSerializer
  include JSONAPI::Serializer

  attributes *Contact::PERMITTED_PARAMS
end

class ContactSerializer < ApiSerializer

  attributes *Contact::PERMITTED_PARAMS
end

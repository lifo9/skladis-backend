class AddressSerializer < ApiSerializer
  attributes *Address::PERMITTED_PARAMS

  attribute :coordinates do |address|
    address.coordinates.to_a
  end
end

class VendorSerializer < ApiSerializer
  attributes *Vendor::PERMITTED_PARAMS

  attribute :logo do |vendor|
    attachment_url(vendor.logo.variant(:thumb)) if vendor.logo.attached?
  end
end

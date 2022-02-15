class SupplierSerializer < ApiSerializer
  attributes *Supplier::PERMITTED_PARAMS

  belongs_to :address
  belongs_to :contact
end

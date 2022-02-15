class WarehouseSerializer < ApiSerializer
  attributes *Warehouse::PERMITTED_PARAMS

  belongs_to :address
end

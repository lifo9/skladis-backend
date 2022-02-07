class WarehouseSerializer < ApiSerializer
  attributes *Warehouse::PERMITTED_PARAMS
end

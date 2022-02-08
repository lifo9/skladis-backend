class WarehouseSerializer < ApiSerializer
  attributes *Warehouse::PERMITTED_PARAMS

  attribute :coordinates do |warehouse|
    warehouse.coordinates.to_a
  end
end

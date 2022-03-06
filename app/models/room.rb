class Room < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :warehouse, class_name: Warehouse.to_s

  PERMITTED_PARAMS = [:name, :warehouse_id].freeze
end

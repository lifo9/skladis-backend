class Room < ApplicationRecord
  include Searchable
  include Orderable

  belongs_to :warehouse

  PERMITTED_PARAMS = [:name, :warehouse_id].freeze
end

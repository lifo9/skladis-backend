class Location < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :room, class_name: Room.to_s

  PERMITTED_PARAMS = [:name, :room_id].freeze
end

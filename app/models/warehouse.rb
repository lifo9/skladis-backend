class Warehouse < ApplicationRecord
  include Searchable
  include Orderable

  belongs_to :address, class_name: Address.to_s
  has_many :rooms, class_name: Room.to_s

  PERMITTED_PARAMS = [:name, :address_id].freeze
end

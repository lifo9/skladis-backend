class Warehouse < ApplicationRecord
  include Searchable
  include Orderable

  PERMITTED_PARAMS = [:name, :street_name, :street_number, :city, :country, coordinates: []].freeze
end

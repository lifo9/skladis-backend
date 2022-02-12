class Warehouse < ApplicationRecord
  include Searchable
  include Orderable

  has_many :rooms

  PERMITTED_PARAMS = [:name, :street_name, :street_number, :city, :country, coordinates: []].freeze
end

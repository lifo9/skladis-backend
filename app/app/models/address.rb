class Address < ApplicationRecord
  PERMITTED_PARAMS = [:id, :street_name, :street_number, :city, :zip, :country, coordinates: []].freeze
end

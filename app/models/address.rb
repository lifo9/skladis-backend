class Address < ApplicationRecord
  PERMITTED_PARAMS = [:street_name, :street_number, :city, :zip, :country, coordinates: []].freeze
  PERMITTED_PARAMS_WITHOUT_COORDINATES = [:street_name, :street_number, :city, :zip, :country].freeze
end

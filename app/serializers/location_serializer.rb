class LocationSerializer < ApiSerializer
  attributes :name

  belongs_to :room
end
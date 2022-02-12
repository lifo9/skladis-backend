class RoomSerializer < ApiSerializer

  attributes :name

  belongs_to :warehouse
end
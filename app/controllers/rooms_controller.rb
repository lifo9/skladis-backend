class RoomsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_room, only: %i[ show update destroy ]

  # GET /rooms
  def index
    authorize Room.all

    @rooms = api_index(Room, params)

    render json: RoomSerializer.new(@rooms, { include: [:warehouse] })
  end

  # GET /rooms/1
  def show
    authorize @room

    render json: RoomSerializer.new(@room, { include: [:warehouse] })
  end

  # GET /rooms/select-options
  def select_options
    authorize Room.all

    render json: api_select_options(Room, [:name], :id, params)
  end

  # POST /rooms
  def create
    authorize Room

    @room = Room.new(room_params)
    serialized_room = RoomSerializer.new(@room, { include: [:warehouse] })

    if @room.save
      render json: serialized_room, status: :created
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1
  def update
    authorize Room

    if @room.update(room_params)
      render json: RoomSerializer.new(@room, { include: [:warehouse] })
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    authorize @room

    @room.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.fetch(:room, {}).permit(Room::PERMITTED_PARAMS)
  end
end

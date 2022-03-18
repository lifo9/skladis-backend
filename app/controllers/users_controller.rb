class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: %i[ show update destroy activate deactivate destroy_avatar ]

  # GET /users
  def index
    authorize User.all

    @users = api_index(User, params)

    render json: UserSerializer.new(@users, { include: [:roles], params: { admin: true } })
  end

  # GET /users/select-options
  def select_options
    render json: api_select_options(User, [:first_name, :last_name], :id, params)
  end

  # GET /users/1
  def show
    authorize @user

    render json: UserSerializer.new(@user, { params: { admin: true }, include: [:roles] })
  end

  # POST /users
  def create
    authorize User

    @user = User.new(user_params)
    serialized_user = UserSerializer.new(@user, { include: [:roles] })

    if @user.save
      render json: serialized_user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    authorize User

    if @user.update(user_params)
      render json: UserSerializer.new(@user, { include: [:roles] })
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    authorize @user

    @user.destroy
  end

  # DELETE /users/1/avatar
  def destroy_avatar
    authorize @user

    @user.avatar.purge
  end

  # POST /users/1/activation
  def activate
    authorize @user

    @user.update(active: true)
  end

  # DELETE /users/1/activation
  def deactivate
    authorize @user

    @user.update(active: false)
    session = JWTSessions::Session.new(namespace: "user_#{@user.id}")
    session.flush_namespaced
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(User::PERMITTED_PARAMS)
  end
end

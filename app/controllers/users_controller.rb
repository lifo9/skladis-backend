class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: %i[ show update destroy activate deactivate ]

  def me
    render json: UserSerializer.new(current_user, { include: [:roles] }).serializable_hash.to_json
  end

  # GET /users
  def index
    authorize User.all

    if params[:search]
      @users = User.search_all_fields(params[:search])
    else
      @users = paginate User.all
    end
    @users = @users.api_order_by(params[:order_by], params[:order]) if params[:order_by] || params[:order]

    render json: UserSerializer.new(@users, { include: [:roles], params: { admin: true } })
  end

  # GET /users/1
  def show
    authorize @user

    render json: UserSerializer.new(@user, { params: { admin: true } })
  end

  # POST /users
  def create
    authorize User

    @user = User.new(user_params)
    serialized_user = UserSerializer.new(@user)

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
      render json: UserSerializer.new(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    authorize @user

    @user.destroy
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

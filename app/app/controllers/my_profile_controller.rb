class MyProfileController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user

  # GET /my-profile
  def index
    render json: UserSerializer.new(@user, { include: [:roles] }).serializable_hash.to_json
  end

  # PATCH/PUT /my-profile
  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy_avatar
    @user.avatar.purge
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(User::MY_PROFILE_PERMITTED_PARAMS)
  end
end

class UsersController < ApplicationController
  before_action :authorize_access_request!

  def me
    render json: UserSerializer.new(current_user).serializable_hash.to_json
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

    render json: UserSerializer.new(@users)
  end
end

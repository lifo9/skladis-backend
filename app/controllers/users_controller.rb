class UsersController < ApplicationController
	before_action :authorize_access_request!

	def me
		render json: UserSerializer.new(current_user).serializable_hash.to_json
	end
end

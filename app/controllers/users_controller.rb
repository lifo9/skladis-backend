class UsersController < ApplicationController
	before_action :authorize_access_request!

	def me
		render json: current_user.as_json(:except => %w[password_digest created_at updated_at])
	end
end

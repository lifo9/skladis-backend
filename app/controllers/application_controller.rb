class ApplicationController < ActionController::API
  def bad_request
    render status: 400
  end
end

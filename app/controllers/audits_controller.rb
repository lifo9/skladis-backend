class AuditsController < ApplicationController
  before_action :authorize_access_request!
  before_action :can_view_audits?

  # GET /audits
  def index
    @logs = api_index(Version, params, false)

    render json: VersionSerializer.new(@logs, { include: [:user] })
  end

  # GET /audits/select-options
  def select_options
    select_options = Version.all.select(:item_type).distinct.map { |version| {
      id: version.item_type,
      label: version.item_type
    } }

    render json: select_options
  end

  private

  def can_view_audits?
    raise Pundit::NotAuthorizedError unless current_user.has_role?(:admin)
  end
end

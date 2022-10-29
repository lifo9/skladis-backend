class VerifyImageController < ApplicationController
  def verify_image
    sgid = params[:sgid]

    if sgid.present?
      verified = ActiveStorage::Blob.find_signed!(sgid)
      return head :ok if verified.present?
    end

    raise Pundit::NotAuthorizedError

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    raise Pundit::NotAuthorizedError
  end
end

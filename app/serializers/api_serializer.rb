class ApiSerializer
  include JSONAPI::Serializer
  singleton_class.include Rails.application.routes.url_helpers

  def self.attachment_url(object, expires_in = nil)
    if Rails.env.production?
      "#{Rails.configuration.x.static_url}/#{object.key}?sgid=#{object.blob.signed_id(expires_in: expires_in)}"
    else
      "#{Rails.configuration.x.static_url}#{rails_blob_url(object, only_path: true, expires_in: expires_in)}?sgid=#{object.blob.signed_id(expires_in: expires_in)}"
    end
  end
end
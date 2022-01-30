class ApiSerializer
  include JSONAPI::Serializer
  singleton_class.include Rails.application.routes.url_helpers

  def self.attachment_url(object)
    if Rails.env.production?
      "#{Rails.configuration.x.static_url}/#{object.key}?sgid=#{object.blob.signed_id}"
    else
      "#{Rails.configuration.x.static_url}#{rails_blob_url(object, only_path: true)}?sgid=#{object.blob.signed_id}"
    end
  end
end
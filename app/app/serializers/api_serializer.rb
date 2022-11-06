class ApiSerializer
  include JSONAPI::Serializer
  singleton_class.include Rails.application.routes.url_helpers

  def self.attachment_url(object, expires_in = 1.hour)
    if Rails.env.production?
      url = "#{Rails.configuration.x.static_url}/#{object.key}"
      expires = (Time.now.getutc + expires_in).to_i.to_s
      key_pair_id = ENV['S3_SIGNING_KEY_PAIR_ID']
      private_key = OpenSSL::PKey::RSA.new(ENV['S3_SIGNING_PRIVATE_KEY'])
      policy = %Q[{"Statement":[{"Resource":"#{url}","Condition":{"DateLessThan":{"AWS:EpochTime":#{expires}}}}]}]
      signature = Base64.strict_encode64(private_key.sign(OpenSSL::Digest::SHA1.new, policy))

      "#{url}?Expires=#{expires}&Signature=#{signature}&Key-Pair-Id=#{key_pair_id}"
    else
      "#{Rails.configuration.x.static_url}#{rails_blob_url(object, only_path: true, expires_in: expires_in)}?sgid=#{object.blob.signed_id(expires_in: expires_in)}"
    end
  end
end
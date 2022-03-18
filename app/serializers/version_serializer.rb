class VersionSerializer < ApiSerializer
  FORBIDDEN_ATTRIBUTES = %w[password_digest registration_key]
  attributes :item_type, :item_id, :event, :created_at

  attribute :changeset do |version|
    version.changeset&.map { |key, value| FORBIDDEN_ATTRIBUTES.include?(key) ? [key, "***"] : [key, value] }.to_h
  end

  belongs_to :user
end

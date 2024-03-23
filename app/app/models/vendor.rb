class Vendor < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  after_save_commit :resize_logo

  has_one_attached :logo do |attachable|
    attachable.variant(:thumb, resize_to_limit: [256, 256])
  end

  PERMITTED_PARAMS = [:name, :url, :logo].freeze

  private

  def resize_logo
    self.logo.variant(:thumb).processed if self.logo.attached?
  end
end

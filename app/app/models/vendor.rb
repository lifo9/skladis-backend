class Vendor < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  has_one_attached :logo do |attachable|
    attachable.variant(:thumb, resize_to_limit: [256, 256])
  end

  after_save_commit :resize_logo

  PERMITTED_PARAMS = [:name, :url, :logo].freeze

  private

  def resize_logo
    self.logo.variant(:thumb).processed if self.logo.attached?
  end
end

class Product < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  after_save_commit :resize_images

  has_and_belongs_to_many :suppliers, class_name: Supplier.to_s
  has_many_attached :images do |attachable|
    attachable.variant(:thumb, resize_to_limit: [256, 256])
    attachable.variant(:normal, resize_to_limit: [1024, 1024])
  end

  belongs_to :barcode, class_name: Barcode.to_s, dependent: :destroy

  PERMITTED_PARAMS = [:name, :order_code, :price, :pieces_package, :pieces_ideal, :pieces_critical, supplier_ids: [], images: []].freeze

  private

  def resize_images
    self.images.each do |image|
      image.variant(:thumb).processed
      image.variant(:normal).processed
    end
  end
end

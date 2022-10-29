class ProductSerializer < ApiSerializer
  attributes :name, :order_code, :pieces_ideal, :pieces_critical

  has_many :suppliers

  attribute :images do |product, params|
    images_url = []

    product.images.sort_by(&:created_at).each do |image|
      type = params[:image_type] || :thumb
      images_url.push({
                        id: image.id,
                        url: attachment_url(image.variant(type))
                      })
    end

    images_url
  end

  attribute :barcode_type do |product|
    product.barcode&.barcode_type
  end

  attribute :barcode_code do |product|
    product.barcode&.barcode_code
  end

  attribute :in_stock do |product|
    product.in_stock
  end
end

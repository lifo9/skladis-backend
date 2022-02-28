class ProductSerializer < ApiSerializer
  attributes :name

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
end

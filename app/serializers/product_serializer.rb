class ProductSerializer < ApiSerializer
  attributes :name

  has_many :suppliers

  attribute :images do |product, params|
    images_url = []

    product.images.each do |image|
      type = params[:image_type] || :thumb
      images_url.push(attachment_url(image.variant(type)))
    end

    images_url
  end
end

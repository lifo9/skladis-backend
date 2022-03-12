class Supplier < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  after_destroy_commit :destroy_address

  belongs_to :address, class_name: Address.to_s
  belongs_to :contact, class_name: Contact.to_s, optional: true
  has_and_belongs_to_many :products, class_name: Product.to_s

  PERMITTED_PARAMS = [:name, :ico, :dic, :url, :free_delivery_from, :contact_id].freeze

  private

  def destroy_address
    self.address.destroy
  rescue ActiveRecord::InvalidForeignKey => _
    # if there is still an association, do not destroy the address - ugly, but works...
  end
end

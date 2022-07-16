class Warehouse < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  after_destroy_commit :destroy_address

  belongs_to :address, class_name: Address.to_s
  has_many :rooms, class_name: Room.to_s

  accepts_nested_attributes_for :address

  PERMITTED_PARAMS = [:name].freeze

  private

  def destroy_address
    self.address.destroy
  rescue ActiveRecord::InvalidForeignKey => _
    # if there is still an association, do not destroy the address - ugly, but works...
  end
end

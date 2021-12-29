module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search_all_fields, -> (searchTerm) {
      where("#{columns.map { |col| col.type == :string ? "lower(#{col.name})" : col.name }.join(' || ')} like ?", "%#{searchTerm.downcase}%")
    }
  end
end
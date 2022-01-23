module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search_all_fields, -> (searchTerm) {
      where("#{columns.map { |col| col.type == :string ? "COALESCE(#{col.name}, lower(#{col.name}), '')" : col.name } # handle null values
                      .join(' || ')} like ?", "%#{searchTerm.downcase}%")
    }
  end
end
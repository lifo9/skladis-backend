module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search_all_fields, -> (searchTerm) {
      where("#{column_names.join(' || ')} like ?", "%#{searchTerm}%")
    }
  end
end
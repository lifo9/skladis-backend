module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search_all_fields, -> (searchTerm, associations) {
      if associations
        all_assoc_attributes = name
                                 .constantize
                                 .reflect_on_all_associations
                                 .select { |assoc| !assoc.name.to_s.include?('attachment') && !assoc.name.to_s.include?('blob') }
                                 .map { |assoc|
                                   [[assoc.name, assoc.plural_name],
                                    assoc.options[:class_name]&.constantize&.columns&.select { |col| col.type == :string } || []
                                   ] }.to_h
      else
        all_assoc_attributes = {}
      end

      join_tables = *all_assoc_attributes.select { |cols| cols.present? }.keys.map { |name_plural_tuple| name_plural_tuple[0] }
      searchable_cols_strings = all_assoc_attributes
                                  .map { |name_plural_tuple, attributes| attributes.map { |col| { type: col.type, name: "#{name_plural_tuple[1]}.#{col.name}" } } }
                                  .flatten
      searchable_cols_strings = searchable_cols_strings + columns.select { |col| col.type == :string }
                                                                 .map { |col| { type: col.type, name: "#{name.constantize.table_name}.#{col.name}" } }

      distinct
        .left_outer_joins(join_tables)
        .where("#{searchable_cols_strings.map { |col| "COALESCE(lower(#{col[:name]}), #{col[:name]}, '')" } # handle null values
                                         .join(' || ')} LIKE ?", "%#{searchTerm.downcase}%")
    }
  end
end
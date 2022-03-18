module Filterable
  extend ActiveSupport::Concern

  included do
    scope :api_filter, -> (params, associations) {
      filtered_params = params.keys.map do |key|
        param_split = key.to_s.split('_', 2)
        if param_split.length == 2
          param_split[0]
        end
      end.compact

      if associations
        all_assoc_attributes = name
                                 .constantize
                                 .reflect_on_all_associations
                                 .select { |assoc| !assoc.name.to_s.include?('attachment') && !assoc.name.to_s.include?('blob') }
                                 .map { |assoc|
                                   [[assoc.name, assoc.plural_name],
                                    assoc.options[:class_name]&.constantize&.columns&.select { |col| col.name == 'id' || col.type == :string } || []
                                   ] }.to_h
      else
        all_assoc_attributes = {}
      end

      join_tables = *all_assoc_attributes.select { |cols| cols.present? }.keys
                                         .map { |name_plural_tuple| name_plural_tuple[0] }
                                         .select { |table_name| filtered_params.include?(table_name.to_s) }

      filterable_cols_strings = all_assoc_attributes
                                  .map { |name_plural_tuple, attributes| attributes.map { |col| { param: "#{name_plural_tuple[0]}_#{col.name}", name: "#{name_plural_tuple[1]}.#{col.name}" } } }
                                  .flatten
      filterable_cols_strings = filterable_cols_strings + columns.select { |col| col.name == 'id' || col.type == :string }
                                                                 .map { |col| { param: "#{name.downcase}_#{col.name}", name: "#{name.constantize.table_name}.#{col.name}" } }

      filters = filterable_cols_strings.select { |col| params.keys.include?(col[:param]) }
                                       .map { |col| [col[:name], params[col[:param]]] }
                                       .to_h

      if filters.present?
        distinct
          .left_outer_joins(join_tables)
          .where(filters)
      end
    }
  end
end
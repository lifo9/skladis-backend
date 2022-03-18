module Orderable
  extend ActiveSupport::Concern

  included do
    scope :api_order_by, -> (order_by, order, associations) {
      all_attributes = name
                         .constantize
                         .reflect_on_all_associations
                         .select { |assoc| !assoc.name.to_s.include?('attachment') && !assoc.name.to_s.include?('blob') }
                         .map { |assoc| [[assoc.name, assoc.plural_name], assoc.options[:class_name]&.constantize&.column_names || []] }.to_h

      if associations
        allowed_assoc_order_by_strings = all_attributes
                                           .map { |name_plural_tuple, attributes| attributes.map { |attr| "#{name_plural_tuple[1]}.#{attr}" } }
                                           .flatten
      else
        allowed_assoc_order_by_strings = []
      end

      allowed_all_order_by_strings = allowed_assoc_order_by_strings + column_names

      if (order_by.present? && allowed_all_order_by_strings.exclude?(order_by)) ||
        (order.present? && [:asc, :desc].exclude?(order.to_sym))
        return # prevent SQL Injection
      end

      if allowed_assoc_order_by_strings.include?(order_by)
        assoc_plural = order_by.split('.')[0]
        assoc_join = all_attributes.keys.to_h.key(assoc_plural)
        if assoc_join
          left_outer_joins(assoc_join).order(order_by ? order_by : :id => order ? order.to_sym : :asc)
        end
      else
        order(order_by ? order_by : :id => order ? order.to_sym : :asc)
      end
    }
  end
end
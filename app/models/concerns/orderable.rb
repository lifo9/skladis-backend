module Orderable
  extend ActiveSupport::Concern

  included do
    scope :api_order_by, -> (order_by, order) {
      if (order_by && column_names.exclude?(order_by)) || (order && [:asc, :desc].exclude?(order.to_sym))
        return # prevent SQL Injection
      end

      order(order_by ? order_by : :id => order ? order.to_sym : :asc)
    }
    end
end
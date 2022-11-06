class StockTransaction < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :user, class_name: User.to_s
  belongs_to :stock, class_name: Stock.to_s, optional: true

  validates :action, inclusion: { in: %w(stock_in stock_out) }, presence: true

  validates_presence_of :stock, if: proc { |transaction| transaction.action&.to_sym == :stock_out }

  validates :pieces, comparison: { greater_than: 0, only_integer: true }, presence: true
end

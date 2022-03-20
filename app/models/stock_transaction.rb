class StockTransaction < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :user, class_name: User.to_s
  belongs_to :stock, class_name: Stock.to_s, optional: true
  belongs_to :room_from, class_name: Room.to_s, foreign_key: 'room_from_id', optional: true
  belongs_to :room_to, class_name: Room.to_s, foreign_key: 'room_to_id', optional: true

  validates :action, inclusion: { in: %w(stock_in stock_out) }

  validates_presence_of :stock, if: [Proc.new { |transaction| transaction.action.to_sym == :stock_out }]

  validates :pieces, comparison: { greater_than: 0, only_integer: true }
  validates_each :pieces do |transaction, attr, value|
    if transaction.action.to_sym == :stock_out
      record.errors.add(attr, I18n.t(:not_enough_pieces)) if transaction.stock && value > transaction.stock.pieces
    end
  end
end

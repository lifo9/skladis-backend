require 'caxlsx'

class StockAuditService
  def self.build_current_stock_audit
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "Stock Audit") do |sheet|
        sheet.add_row ["Product Code", "Product Name", "Supplier", "Current Stock", "Unit Price", "Total Value"]
        Product.includes(:stocks, :suppliers).find_each(batch_size: 1000) do |product|
          in_stock       = product.stocks.sum(&:pieces)
          unit_price     = get_latest_unit_price(product.id)
          supplier_names = get_supplier_names(product)
          total_value    = in_stock * unit_price
          sheet.add_row [
                          product.order_code,
                          product.name,
                          supplier_names,
                          in_stock,
                          unit_price.round(3),
                          total_value.round(3)
                        ], types: [:string, :string, :string, :integer, :float, :float]
        end
      end
      return p.to_stream.read
    end
  end

  private

  def self.get_latest_unit_price(product_id)
    @unit_prices ||= latest_product_prices_hash
    @unit_prices[product_id] || 0
  end

  def self.get_supplier_names(product)
    product.suppliers.pluck(:name).join(', ')
  end

  def self.latest_product_prices_hash
    @latest_product_prices ||= InvoiceItem.joins(:invoice)
                                          .select('DISTINCT ON (product_id) product_id, unit_price')
                                          .order('product_id, invoices.invoice_date DESC')
                                          .pluck(:product_id, :unit_price)
                                          .to_h
  end
end
class StockAuditService
  def self.build_current_stock_audit
    unit_prices = latest_product_prices_hash

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "Stock Audit") do |sheet|
        sheet.add_row ["Product Code", "Product Name", "Supplier", "Current Stock", "Unit Price", "Total Value"]
        Product.includes(:stocks, :suppliers).find_each(batch_size: 1000) do |product|
          in_stock       = product.stocks.sum(&:pieces)
          unit_price     = unit_prices[product.id] || 0
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

  def self.get_supplier_names(product)
    product.suppliers.pluck(:name).join(', ')
  end

  def self.latest_product_prices_hash
    sql = <<-SQL
      SELECT product_id, unit_price
      FROM (
        SELECT product_id, unit_price,
               ROW_NUMBER() OVER (PARTITION BY product_id 
                                 ORDER BY invoices.invoice_date DESC, 
                                         invoice_items.id DESC) as rn
        FROM invoice_items
        JOIN invoices ON invoices.id = invoice_items.invoice_id
      ) ranked_items
      WHERE rn = 1
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    results.to_a.map { |row| [row['product_id'], row['unit_price']] }.to_h
  end
end
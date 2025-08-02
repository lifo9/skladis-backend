require 'csv'

class StockAuditService
  def self.build_current_stock_audit
    total_price = 0

    CSV.generate do |csv|
      csv << ["Product Code", "Product Name", "Supplier", "Current Stock", "Unit Price", "Total Value"]

      Product.includes(:stocks).find_each(batch_size: 1000) do |product|
        in_stock      = product.stocks.sum(&:pieces)
        unit_price    = get_latest_unit_price(product.id)
        supplier_name = get_latest_supplier_name(product.id)
        total_value   = in_stock * unit_price
        total_price   += total_value

        csv << [product.order_code, product.name, supplier_name, in_stock, unit_price.round(3), total_value.round(3)]
      end

      csv << ["", "", "", "", "TOTAL:", total_price.to_f.round(3)]
    end
  end

  private

  def self.get_latest_unit_price(product_id)
    @unit_prices ||= latest_product_data_hash
    @unit_prices[product_id]&.unit_price.to_f || 0
  end

  def self.get_latest_supplier_name(product_id)
    @supplier_names ||= latest_product_data_hash
    @supplier_names[product_id]&.supplier_name || "Unknown"
  end

  def self.latest_product_data_hash
    @latest_product_data ||= InvoiceItem.joins(:invoice, :supplier)
                                        .select('DISTINCT ON (product_id) product_id, unit_price, suppliers.name as supplier_name')
                                        .order('product_id, invoices.invoice_date DESC')
                                        .index_by(&:product_id)
  end
end

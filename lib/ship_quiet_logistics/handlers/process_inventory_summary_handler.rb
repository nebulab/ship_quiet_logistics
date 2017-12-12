module ShipQuietLogistics
  module Handlers
    class ProcessInventorySummaryHandler
      def self.call(document)
        stock_location_name = document.warehouse
        stock_location = ::Spree::StockLocation.find_by_name(stock_location_name)

        document.inventories.each do |inventory|
          sku = inventory.item_number
          quantity = inventory.quantity_available
          variant = ::Spree::Variant.find_by_sku(sku)
          next unless variant

          stock_item = variant.stock_items.find_by_stock_location_id(stock_location.id)
          stock_item.set_count_on_hand(quantity.to_i)
        end
      end
    end
  end
end

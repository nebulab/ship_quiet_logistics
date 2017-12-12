module ShipQuietLogistics
  class Processor
    def initialize(bucket)
      @bucket = bucket
    end

    def process_doc(msg)
      name = msg[:document_name]
      type = msg[:document_type]

      return if type == 'error'

      if type == 'InventoryEventMessage'
        data = msg
      else
        downloader = Downloader.new(@bucket)
        data = downloader.download(name)
      end

      # downloader.delete_file(name)

      parse_doc(type, data)
    end

    private

    def parse_doc(type, data)
      case type
      when 'ShipmentOrderResult'
        Documents::ShipmentOrderResult.new(data)
      when 'PurchaseOrderReceipt'
        Documents::PurchaseOrderReceipt.new(data)
      when 'RMAResultDocument'
        Documents::RMAResult.new(data)
      when 'InventoryEventMessage'
        Documents::InventoryAdjustment.new(data)
      when 'InventorySummary'
        Documents::InventorySummaryResult.new(data)
      else
        Struct.new(:type).new(:unknown)
      end
    end
  end
end

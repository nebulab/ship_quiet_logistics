module ShipQuietLogistics
  class Api
    def self.send_document(type, content, bucket, queue, config)
      document =
      case type
      when 'ShipmentOrder'
        Documents::ShipmentOrder.new(content, config)
      when 'RMADocument'
        ::Gentle::Documents::Request::RMADocument.new(rma:content, config:config)
      end
      uploader = Uploader.new(bucket)
      uploader.process(document.name, document.to_xml)

      event_message = EventMessage.new(type, document.name, config)
      sender = Sender.new(queue)
      sender.send_message(event_message)

      document.message
    end
  end
end

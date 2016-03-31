module ShipQuietLogistics
  class Sender
    attr_reader :sqs

    def initialize(queue)
      @config = ShipQuietLogistics.configuration
      @sqs = AWS::SQS.new(@config.aws)
      @queue = queue
    end

    def send_message(event_message)
      queue = sqs.queues[@queue]
      sqs_message = queue.send_message(event_message.to_xml)
      sqs_message.id
    end
  end
end

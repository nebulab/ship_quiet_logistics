module ShipQuietLogistics
  class Sender
    attr_reader :sqs

    def initialize(bucket)
      @sqs = AWS::SQS.new
      @queue = bucket
    end

    def send_message(event_message)
      queue = sqs.queues[@queue]
      sqs_message = queue.send_message(event_message.to_xml)
      sqs_message.id
    end
  end
end

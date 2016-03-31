module ShipQuietLogistics
  class Receiver
    attr_reader :sqs, :count

    def initialize(queue)
      @config = ShipQuietLogistics.configuration
      @sqs = AWS::SQS.new(@config.aws)
      @limit = 10
      @queue = queue
      @count = 0
    end

    def receive_messages
      queue = sqs.queues[@queue]

      4.times do
        queue.receive_message(limit: @limit) do |sqs_message|
          msg = Messages::MessageParser.parse(sqs_message)

          next if msg.empty?
          @count += 1

          yield(msg)
        end
      end
    end
  end
end

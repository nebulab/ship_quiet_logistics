ShipQuietLogistics.configure do |config|
  config.outgoing_bucket  = ENV['OUTGOING_BUCKET']
  config.outgoing_queue   = ENV['OUTGOING_QUEUE']
  config.incoming_bucket  = ENV['INCOMING_BUCKET']
  config.incoming_queue   = ENV['INCOMING_QUEUE']
  config.business_unit    = ENV['BUSINESS_UNIT']
  config.client_id        = ENV['CLIENT_ID']
end

AWS.config(sqs_verify_checksums: false)

ShipQuietLogistics.configure do |config|
  config.outgoing_bucket  = ENV['QUIET_OUTGOING_BUCKET']
  config.outgoing_queue   = ENV['QUIET_OUTGOING_QUEUE']
  config.incoming_bucket  = ENV['QUIET_INCOMING_BUCKET']
  config.incoming_queue   = ENV['QUIET_INCOMING_QUEUE']
  config.inventory_queue  = ENV['QUIET_INVENTORY_QUEUE']
  config.business_unit    = ENV['QUIET_BUSINESS_UNIT']
  config.client_id        = ENV['QUIET_CLIENT_ID']
end

AWS.config(sqs_verify_checksums: false)

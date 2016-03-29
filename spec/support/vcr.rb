require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<AMAZON_ACCESS_KEY>') { ENV['AMAZON_ACCESS_KEY'] }
  c.filter_sensitive_data('<AMAZON_SECRET_KEY>') { ENV['AMAZON_SECRET_KEY'] }
end

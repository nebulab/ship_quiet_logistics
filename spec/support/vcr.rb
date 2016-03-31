require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<QUIET_AWS_ACCESS_KEY>') { ENV['QUIET_AWS_ACCESS_KEY'] }
  c.filter_sensitive_data('<QUIET_AWS_ACCESS_KEY>') { ENV['QUIET_AWS_ACCESS_KEY'] }
end

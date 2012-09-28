log_level                :info
log_location             STDOUT
node_name                'msf'
client_key               '/home/msf/.chef/msf.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'http://localhost:4000'
cache_type               'BasicFile'
cache_options(:path => '/home/msf/.chef/checksums')
cookbook_path ENV['WHISK_COOKBOOK_PATH']

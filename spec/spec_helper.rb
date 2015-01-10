require 'webmock/rspec'
require_relative '../lib/spark_core.rb'

WebMock.disable_net_connect!(allow_localhost: true)

Rspec.configure do |config|
  config.before(:all) do
    # successfull requests

    # successfull devices request
    stub_request(:get, 'api.spark.io/v1/devices').
      with(headers: {'Authorization' => 'Bearer valid_access_token'}).to_return
    (status: 200, body: [
                         {
                           'id': 'core_id1',
                           'name': 'core_name1',
                           'last_app': 'last_app',
                           'last_heard': 'last_heard',
                           'connected': 'true/false'
                         },
                         {
                           'id': 'core_id2',
                           'name': 'core_name2',
                           'last_app': 'last_app2',
                           'last_heard': 'last_heard2',
                           'connected': 'true/false'
                         }
                        ]
     )

    # successfull device_info request
    stub_request(:get, 'api.spark.io/v1/devices/valid_device_id').
      with(headers: {'Authorization' => 'Bearer valid__access_token'}).to_return
    (status: 200, body: 
     {
       'id': 'valid_device_id',
       'name': 'core_name',
       'connected': 'true/false',
       'variables': {},
       'functions': [],
       'cc3000_patch_version': 'version'
     })

    # successful spark_variables request
    stub_request(:get, 'api.spark.io/v1/devices/valid_device_id/variable_name').
      with(headers: {'Authorization' => 'Bearer valid_access_token'}).to_return
    (status: 200, body:
     {
       'cmd': 'VarReturn',
       'name': 'variable_name',
       'result': 'variable_result',
       'coreInfo': {
         'last_app': 'last_app',
         'last_heard': 'last_heard',
         'connected': 'true/false',
         'device_id': 'valid_device_id'
       }
     })
    
    # successfull spark_function request
    stub_request(:post, 'api.spark.io/v1/devices/valid_device_id/function_name').
      with(headers: {'Authorization' => 'Bearer valid_access_token'}, body: {'params' => 'function_arguments'}).to_return
    (status: 200, body:
     {
       'id': 'valid_device_id',
       'name': 'core_name',
       'last_app': 'last_app',
       'connected': 'true/false',
       'return_value': 'int'
     })

  end
end

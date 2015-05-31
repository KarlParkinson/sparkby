require_relative 'http_caller'

module Sparkby

  # Main core driver. Exposes ability to read Spark variable,
  # call Spark function, view device info, and view other
  # devices.
  class SparkCore
    
    # Particle API access token
    attr_accessor :access_token
    # Device ID of Particle core
    attr_accessor :device_id
    
    # ==== Arguments
    # * +access_token+ - Particle API access token
    # * +device_id+ - Device ID of Particle core
    def initialize(access_token, device_id)
      @access_token = access_token
      @device_id = device_id
      @http_caller = HTTPCaller.new
      @header = {"Authorization" => "Bearer #{@access_token}"}
    end

    # View devices authenticated user has access to
    def devices
      @http_caller.get '/v1/devices', @header
    end
    
    # View information about device
    def device_info
      @http_caller.get '/v1/devices/' + @device_id, @header
    end

    # Read the value of a Spark variable
    # ==== Arguments
    # * +variable_name+ - Name of the Spark variable
    def spark_variable(variable_name)
      @http_caller.get '/v1/devices/' + @device_id + '/' + variable_name, @header
    end

    # Call a Spark function
    # ==== Arguments
    # * +function+ - Name of the Spark function
    # * +args+ - Argument string to pass to Spark function
    def spark_function(function, args=nil)
      @http_caller.post '/v1/devices/' + @device_id + '/' + function, {'params' => args}, nil, @header
    end
    
  end

end

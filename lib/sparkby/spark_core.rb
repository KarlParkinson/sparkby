require 'httparty'

module Sparkby

  # Main core driver. Exposes ability to read Spark variable,
  # call Spark function, view device info, and view other
  # devices.
  class SparkCore
    include HTTParty
    base_uri 'https://api.particle.io'
    
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
    end

    # View devices authenticated user has access to
    def devices
      get '/v1/devices'
    end
    
    # View information about device
    def device_info
      get '/v1/devices/' + @device_id
    end

    # Read the value of a Spark variable
    # ==== Arguments
    # * +variable_name+ - Name of the Spark variable
    def spark_variable(variable_name)
      get '/v1/devices/' + @device_id + '/' + variable_name
    end

    # Call a Spark function
    # ==== Arguments
    # * +function+ - Name of the Spark function
    # * +args+ - Argument string to pass to Spark function
    def spark_function(function, args=nil)
      post '/v1/devices/' + @device_id + '/' + function, {'params' => args}
    end

    private
    
    def get(url, basic_auth = nil)
      response = self.class.get(url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :basic_auth => basic_auth)
    end

    def post(url, body, basic_auth = nil)
      response = self.class.post(url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :basic_auth => basic_auth, :body => body)
    end

    def post_oauth(url, body, basic_auth = nil)
      response = self.class.post(url, :basic_auth => basic_auth, :body => body)
    end

    def delete(url, basic_auth = nil)
      response = self.class.delete(url, :basic_auth => basic_auth)
    end

  end

end

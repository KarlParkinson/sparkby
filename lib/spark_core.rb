require 'httparty'

class SparkCore
  include HTTParty
  base_uri 'https://api.spark.io/v1'
  
  def initialize(access_token, device_id)
    @access_token = access_token
    @device_id = device_id
  end

  def devices
    get '/devices'
  end

  def device_info
    get '/devices/' + @device_id
  end

  def spark_variable(variable_name)
    get '/devices/' + @device_id + '/' + variable_name
  end

  def spark_function(function, args=nil)
    post '/devices/' + @device_id + '/' + function, args
  end

  def access_tokens(email, password)
    get '/access_tokens', {:username => email, :password => password}
  end


  private
  
  def get(url, basic_auth = {})
    response = self.class.get(url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :basic_auth => basic_auth)
#    puts response.code
    response
  end

  def post(url, params, basic_auth = {})
#    puts url
    response = self.class.post(url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :basic_auth => basic_auth, :body => {'params' => params})
    response
  end

  def put
  end

end

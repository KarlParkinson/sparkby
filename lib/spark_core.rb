require 'httparty'

class SparkCore

  def initialize(access_token)
    @base_url = 'https://api.spark.io/v1'
    @access_token = access_token
  end

  def devices
    get '/devices'
  end

  def device_info(device_id)
    get '/devices/' + device_id
  end

  def spark_function(device_id, function, args=nil)
    post '/devices/' + device_id + '/' + function, args
  end


  private
  
  def get(url)
    response = HTTParty.get(@base_url + url, :headers => {"Authorization" => "Bearer #{@access_token}"})
    response.parsed_response
  end

  def post(url, params)
    response = HTTParty.post(@base_url + url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :body => {'params' => params})
    response.parsed_response
  end

  def put
  end

end

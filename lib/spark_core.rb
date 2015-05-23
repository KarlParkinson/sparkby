require 'httparty'

class SparkCore
  include HTTParty
  base_uri 'https://api.particle.io'

  attr_accessor :access_token
  attr_accessor :device_id
  
  def initialize(access_token, device_id)
    @access_token = access_token
    @device_id = device_id
  end

  def devices
    get '/v1/devices'
  end

  def device_info
    get '/v1/devices/' + @device_id
  end

  def spark_variable(variable_name)
    get '/v1/devices/' + @device_id + '/' + variable_name
  end

  def spark_function(function, args=nil)
    post '/v1/devices/' + @device_id + '/' + function, {'params' => args}
  end

  def access_tokens(email, password)
    get '/v1/access_tokens', {:username => email, :password => password}
  end

  def gen_access_token(email, password, expires_in = nil)
    post '/oauth/token', {:grant_type => 'password', :username => email, :password => password, :expires_in => expires_in}.reject{ |k,v| v.nil?}, {:id => 'particle', :password => 'particle'}
  end

  def del_access_token(email, password, token)
    delete '/v1/access_tokens/' + token, {:username => email, :password => password}
  end

  private
  
  def get(url, basic_auth = nil)
    response = self.class.get(url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :basic_auth => basic_auth)
    response
  end

  def post(url, body, basic_auth = nil)
    response = self.class.post(url, :headers => {"Authorization" => "Bearer #{@access_token}"}, :basic_auth => basic_auth, :body => body.to_json)
    response
  end

  def delete(url, basic_auth = nil)
    response = self.class.delete(url, :basic_auth => basic_auth)
    response
  end

end

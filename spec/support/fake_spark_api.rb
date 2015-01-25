require 'sinatra/base'

class FakeSparkApi < Sinatra::Base

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      if @auth.credentials == ['valid_email', 'wrong_password']
        halt 401, {'Content-Type' => 'text/json'}, File.open(File.dirname(__FILE__) + '/fixtures/invalid_password_access_tokens.json', 'rb').read
      elsif @auth.credentials == ['invalid_email', 'correct_password']
        halt 401, {'Content-Type' => 'text/json'}, File.open(File.dirname(__FILE__) + '/fixtures/invalid_email_access_tokens.json', 'rb').read
      end
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['valid_email', 'correct_password']
    end
  end
  
  get '/v1/devices' do
    json_response 200, 'devices.json'
  end

  get '/v1/devices/:id' do
    #puts request.to_yaml
    json_response 200, 'device_info.json'
  end

  get '/v1/devices/:id/:variable' do
    if params[:variable] == 'valid_variable_name'
      json_response 200, 'variable_request.json'
    else
      json_response 404, 'invalid_variable.json'
    end
  end

  post '/v1/devices/:id/:function' do
    if params[:function] == 'valid_function_name'
      json_response 200, 'function_call.json'
    else
      json_response 400, 'invalid_function_call.json'
    end
  end

  get '/v1/access_tokens' do
    protected!
    json_response 200, 'get_access_tokens.json'
  end

  private
  
  def json_response(code, file_name)
    content_type :json
    status code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end

end

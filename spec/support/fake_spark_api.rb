require 'sinatra/base'

class FakeSparkApi < Sinatra::Base
  
  get '/v1/devices' do
    json_response 200, 'devices.json'
  end

  get '/v1/devices/:id' do
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
    puts headers
  end

  private
  
  def json_response(code, file_name)
    content_type :json
    status code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end

end

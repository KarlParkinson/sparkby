require 'json'
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

    def check_username_and_password_in_body(body)
      args = JSON.parse(body.read)
      if args["username"] != 'valid_email' and args["password"] != 'correct_password'
        halt 401, {'Content-Type' => 'text/json'}, File.open(File.dirname(__FILE__) + '/fixtures/invalid_email_password_combo.json', 'rb').read
      end
    end
  end
  
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
    protected!
    json_response 200, 'get_access_tokens.json'
  end

  post '/oauth/token' do
    check_username_and_password_in_body(request.body)
    request.body.rewind
    args = JSON.parse(request.body.read)
    if args.has_key?("expires_in")
      json_response 200, 'gen_access_token_expiry.json'
    else
      json_response 200, 'gen_access_token_no_expiry.json'
    end
  end

  delete '/v1/access_tokens/:token' do
    protected!
    json_response 200, 'delete_access_token.json'
  end

  private
  
  def json_response(code, file_name)
    content_type :json
    status code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end

end

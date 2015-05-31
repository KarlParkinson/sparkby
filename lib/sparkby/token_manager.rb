require_relative 'http_caller'

module Sparkby

  class TokenManager

    # Email address of Particle account
    attr_accessor :email
    # Password of Particle account
    attr_accessor :password

    def initialize(email, password)
      @email = email
      @password = password
      @http_caller = HTTPCaller.new
    end

    # Generate a new access token
    # ==== Arguments
    # * +expires_in+ - Time in seconds when token should expire, nil means token never expires
    # * +expires_at+ - Time in YYYY-MM-DD Format when token should expire. At most one of expires_in and expires_at should be specified
    # * +client_id+ - Particle client ID
    # * +client_secret+ - Particle client secret
    #
    # ==== Examples
    #
    # Token that expires in 3600 seconds (one hour)
    #    manager = TokenManager.new email, pass
    #    manager.gen_access_token 3600
    #
    # Token that expires on September 25, 2015
    #    manager = TokenManager.new email, pass
    #    manager.gen_access_token nil, '2015-09-25'
    def gen_access_token(expires_in = nil, expires_at = nil, client_id = 'particle', client_secret = 'particle')
      @http_caller.post '/oauth/token', {:grant_type => 'password', :username => @email, :password => @password,
        :expires_in => expires_in, :expires_at => expires_at}.reject{ |k,v| v.nil?},
      {:username => client_id, :password => client_secret}
    end

    # Delete an access token
    # ==== Arguments
    # * +token+ - Access token to delete
    def del_access_token(token)
      @http_caller.delete '/v1/access_tokens/' + token, {:username => @email, :password => @password}
    end

    # List all access tokens the user has
    def list_tokens
      @http_caller.get '/v1/access_tokens', nil, {:username => @email, :password => @password}
    end

  end
end

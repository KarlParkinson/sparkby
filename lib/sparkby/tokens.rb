require 'httparty'

module Sparkby

  # Generate a new access token
  # ==== Arguments
  # * +email+ - Email address of Particle account
  # * +password+ - Password of Particle account
  # * +expires_in+ - Time in seconds when token should expire, nil means token never expires
  # * +expires_at+ - Time in YYY-MM-DD Format when token should expire
  # * +client_id+ - Particle client ID
  # * +client_secret+ - Particle client secret
  def self.gen_access_token(email, password, expires_in = nil, expires_at = nil, client_id = 'particle', client_secret = 'particle')
    post_oauth 'https://api.particle.io/oauth/token', {:grant_type => 'password', :username => email, :password => password,
      :expires_in => expires_in, :expires_at => expires_at}.reject{ |k,v| v.nil?},
    {:username => client_id, :password => client_secret}
  end

  # Delete an access token
  # ==== Arguments
  # * +email+ - Email address of Particle account
  # * +password+ - Password of Particle account
  # * +token+ - Access token to delete
  def self.del_access_token(email, password, token)
    delete 'https://api.particle.io/v1/access_tokens/' + token, {:username => email, :password => password}
  end

  # List all access tokens the user has
  # * +email+ - Email address of Particle account
  # * +password+ - Password of Particle account
  def self.list_tokens(email, password)
      get 'https://api.particle.io/v1/access_tokens', {:username => email, :password => password}
  end

  def self.post_oauth(url, body, basic_auth = nil)
    response = HTTParty.post(url, :basic_auth => basic_auth, :body => body)
  end

  def self.delete(url, basic_auth = nil)
    response = HTTParty.delete(url, :basic_auth => basic_auth)
  end

  def self.get(url, basic_auth = nil)
    response = HTTParty.get(url, :basic_auth => basic_auth)
  end

end


require 'httparty'

module Sparkby

  class HTTPCaller
    include HTTParty
    base_uri 'https://api.particle.io'

    def get(url, header = nil, basic_auth = nil)
      self.class.get(url, :headers => header, :basic_auth => basic_auth)
    end

    def post(url, body, basic_auth = nil, header = nil)
      self.class.post(url, :headers => header, :basic_auth => basic_auth, :body => body)
    end

    def delete(url, basic_auth = nil)
      self.class.delete(url, :basic_auth => basic_auth)
    end

  end

end

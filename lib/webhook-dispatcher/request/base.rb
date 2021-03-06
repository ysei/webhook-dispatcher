
require "uri"
require "webhook-dispatcher/core"

class WebHookDispatcher
  module Request
  end
end

class WebHookDispatcher::Request::Base
  def initialize(uri)
    @uri = uri
  end

  attr_accessor :uri

  def create_http_connector
    return Net::HTTP.new(self.uri.host, self.uri.port)
  end

  def create_http_request
    raise(NotImplementedError)
  end
end

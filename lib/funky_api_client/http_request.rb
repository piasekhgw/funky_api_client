module FunkyApiClient
  class HttpRequest
    def self.perform(method_type, path, query: {}, body: {}, headers: {})
      HTTParty.public_send(
        method_type,
        path,
        query: query,
        body: body,
        headers: headers
      )
    end
  end
end

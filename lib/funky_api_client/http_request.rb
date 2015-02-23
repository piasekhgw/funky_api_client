module FunkyApiClient
  class HttpRequest
    def self.perform(method_type, path, query: {}, body: {}, headers: {})
      HTTParty.public_send(
        method_type,
        full_path(path),
        query: query,
        body: body,
        headers: headers
      )
    end

    def self.full_path(path)
      URI.join(FunkyApiClient.backend_url, path).to_s
    end
  end
end

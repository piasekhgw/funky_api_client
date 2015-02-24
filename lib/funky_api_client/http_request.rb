module FunkyApiClient
  class HttpRequest
    include HTTParty
    headers 'Content-Type' => 'application/json'

    def self.perform(method_type, relative_path, query: {}, body: {}, headers: {})
      public_send(
        method_type,
        full_path(relative_path),
        query: query,
        body: body,
        headers: headers
      )
    end

    def self.full_path(relative_path)
      URI.join(FunkyApiClient.backend_url, relative_path).to_s
    end
  end
end

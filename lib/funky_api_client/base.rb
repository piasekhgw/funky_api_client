module FunkyApiClient
  class Base
    include Virtus.model
    include FunkyApiClient::ApiCalls

    attribute :response_errors, Array[String]

    def valid?
      response_errors.empty?
    end
  end
end

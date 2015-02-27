module FunkyApiClient
  class Base
    include Virtus.model
    include ActiveModel::Validations
    include FunkyApiClient::ApiCalls

    attribute :response_errors, Array[String]
  end
end

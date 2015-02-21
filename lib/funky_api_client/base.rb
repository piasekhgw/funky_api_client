module FunkyApiClient
  class Base
    include Virtus.model
    include ActiveModel::Validations
    include FunkyApiClient::ApiCalls
  end
end

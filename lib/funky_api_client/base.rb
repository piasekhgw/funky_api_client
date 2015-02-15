module FunkyApiClient
  class Base
    include Virtus.model
    include ActiveModel::Validations
    extend FunkyApiClient::ApiCalls
  end
end

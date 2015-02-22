module FunkyApiClient
  module ApiCalls
    extend ActiveSupport::Concern

    included do
      extend FunkyApiClient::ResponseHandlers::ClassCallHandler
    end

    module ClassMethods
      def class_call(method_name, path, plain_response = false)
        define_singleton_method(method_name) do |params: {}, headers: {}|
          path_parser = FunkyApiClient::PathParser.new(path)
          response = FunkyApiClient::HttpRequest.perform(
            :get,
            path_parser.call(params),
            query: params.stringify_keys.slice(*path_parser.ruote_keys),
            headers: headers
          )
          handle_class_call_response(response, plain_response)
        end
      end

      def instance_call(method_name, path, method_type, serialization_method_name = nil)
      end
    end
  end
end

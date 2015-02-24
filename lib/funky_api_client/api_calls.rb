module FunkyApiClient
  module ApiCalls
    extend ActiveSupport::Concern

    included do
      extend FunkyApiClient::ResponseHandlers::ClassCallHandler
      include FunkyApiClient::ResponseHandlers::InstanceCallHandler
    end

    module ClassMethods
      def class_call(method_name, relative_path, plain_response = false)
        define_singleton_method(method_name) do |params: {}, headers: {}|
          path_parser = FunkyApiClient::PathParser.new(relative_path)
          response = FunkyApiClient::HttpRequest.perform(
            :get,
            path_parser.call(params),
            query: params.stringify_keys.slice(*path_parser.ruote_keys),
            headers: headers
          )
          handle_class_call_response(response, plain_response)
        end
      end

      def instance_call(method_name, relative_path, method_type, serialization_method_name = nil)
        define_method(method_name) do |params: {}, headers: {}|
          path_parser = FunkyApiClient::PathParser.new(relative_path)
          response = FunkyApiClient::HttpRequest.perform(
            method_type,
            path_parser.call(params),
            query: params.stringify_keys.slice(*path_parser.ruote_keys),
            body: serialization_method_name ? send(serialization_method_name) : nil,
            headers: headers
          )
          handle_instance_call_response(response)
        end
      end
    end
  end
end

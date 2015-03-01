module FunkyApiClient
  module ResponseHandlers
    module ClassCallHandler
      def handle_class_call_response(response, plain_response)
        if response.success?
          handle_class_call_success_response(response, plain_response)
        else
          handle_class_call_error_response(response)
        end
      end

      private

      def handle_class_call_success_response(response, plain_response)
        return response.body if plain_response
        parsed_response = JSON.parse(response.body)
        if parsed_response.is_a?(Array) && parsed_response.all? { |e| e.is_a?(Hash) }
          parsed_response.map { |attributes| new(attributes) }
        elsif parsed_response.is_a?(Hash)
          new(parsed_response)
        end
      rescue JSON::ParserError
        raise FunkyApiClient::Errors::GenericError
      end

      def handle_class_call_error_response(response)
        case response.code
        when 404
          raise FunkyApiClient::Errors::RecordNotFoundError
        else
          raise FunkyApiClient::Errors::GenericError
        end
      end
    end
  end
end

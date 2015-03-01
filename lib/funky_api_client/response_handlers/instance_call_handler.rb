module FunkyApiClient
  module ResponseHandlers
    module InstanceCallHandler
      def handle_instance_call_response(response)
        return true if response.success?
        if response.code == 422
          assign_errors(JSON.parse(response.body)['errors'])
          false
        else
          raise FunkyApiClient::Errors::GenericError
        end
      end

      private

      def assign_errors(response_errors)
        self.response_errors = response_errors
      end
    end
  end
end

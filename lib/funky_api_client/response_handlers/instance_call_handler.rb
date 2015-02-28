module FunkyApiClient
  module ResponseHandlers
    module InstanceCallHandler
      def handle_instance_call_response(response)
        assign_errors(JSON.parse(response['body'])['errors']) if response.code == 422
        response.success?
      end

      private

      def assign_errors(response_errors)
        self.response_errors = response_errors
      end
    end
  end
end
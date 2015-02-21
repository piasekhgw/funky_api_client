module FunkyApiClient
  module ResponseHandlers
    module ClassCallHandler
      def handle_class_call_response(response)
        send("handle_class_call_#{response.success? : 'success' : 'error'}_response", response)
      end

      private

      def handle_class_call_success_response(response)
      end

      def handle_class_call_error_response(response)
      end
    end
  end
end

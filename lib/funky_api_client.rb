require 'funky_api_client/version'
require 'virtus'
require 'active_model'
require 'active_support/core_ext/hash/keys'
require 'httparty'

module FunkyApiClient
  autoload :Base, 'funky_api_client/base'
  autoload :ApiCalls, 'funky_api_client/api_calls'
  autoload :HttpRequest, 'funky_api_client/http_request'
  autoload :PathParser, 'funky_api_client/path_parser'

  module ResponseHandlers
    autoload :ClassCallHandler,  'funky_api_client/response_handlers/class_call_handler'
  end
end

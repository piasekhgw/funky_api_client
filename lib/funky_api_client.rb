require 'funky_api_client/version'
require 'virtus'
require 'active_support/concern'
require 'active_support/core_ext/hash'
require 'httparty'

module FunkyApiClient
  autoload :Base, 'funky_api_client/base'
  autoload :ApiCalls, 'funky_api_client/api_calls'
  autoload :HttpRequest, 'funky_api_client/http_request'
  autoload :PathParser, 'funky_api_client/path_parser'

  module ResponseHandlers
    autoload :ClassCallHandler, 'funky_api_client/response_handlers/class_call_handler'
    autoload :InstanceCallHandler, 'funky_api_client/response_handlers/instance_call_handler'
  end

  module Errors
    autoload :RecordNotFoundError, 'funky_api_client/errors/record_not_found_error'
    autoload :GenericError, 'funky_api_client/errors/generic_error'
    autoload :InvalidParamsError, 'funky_api_client/errors/invalid_params_error'
  end

  def self.backend_url=(url)
    @backend_url = url
  end

  def self.backend_url
    @backend_url
  end
end

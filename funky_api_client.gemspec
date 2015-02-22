# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funky_api_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'funky_api_client'
  spec.version       = FunkyApiClient::VERSION
  spec.authors       = ['piasekhgw']
  spec.email         = ['piaseckiwojciechh@gmail.com']
  spec.summary       = 'API mapper'
  spec.description   = 'ORM that maps API responses to ruby objects in Rails style'
  spec.homepage      = 'https://github.com/piasekhgw/funky_api_client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.13.3'
  spec.add_dependency 'virtus', '~> 1.0.4'
  spec.add_dependency 'activemodel', '~> 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end

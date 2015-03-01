module FunkyApiClient
  class PathParser
    attr_reader :ruote_keys

    def initialize(path_pattern)
      @path_pattern = path_pattern
      @ruote_keys ||= path_pattern.scan(/\/:(\w+)/).flatten
    end

    def call(params)
      params.stringify_keys!
      raise FunkyApiClient::Errors::InvalidParamsError unless @ruote_keys.to_set.subset?(params.keys.to_set)
      result_path = @path_pattern.dup
      @ruote_keys.each do |ruote_key|
        result_path.sub!(/:#{ruote_key}(\W|$)/) { |match| match.sub!(/:\w+/, params[ruote_key].to_s) }
      end
      result_path
    end
  end
end

module VWorkApp
  
  # Error raised on a bad response
  class ResponseError < StandardError
    
    attr_reader :response, :code, :errors
    
    def initialize(res)
      @response = res.response
      @code     = res.code
      @errors   = parse_errors(res.parsed_response)
    end
    
    def to_s
      p @response.body
      "#{code.to_s} #{response.msg}".strip
    end
    
    private
    
    def parse_errors(errors)
      return case errors
        when Hash
           errors.collect{|k,v| "#{k}: #{v}"}
        when String
           [errors]
        when Array
           errors
        else []
      end
    end
    
  end
  
end
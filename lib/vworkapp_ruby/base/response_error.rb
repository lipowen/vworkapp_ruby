module VWorkApp
  
  # Error raised on a bad response
  class ResponseError < StandardError
    attr_reader :response, :code, :errors
    
    def initialize(res)
      @response = res.response
      @code     = res.response.code
      @errors   = extract_errors(res.parsed_response)
    end
    
    def to_s
      "#{code.to_s} - #{response.msg}:\n#{@errors && @errors.join("\n")}".strip
    end
    
  private
    
    def extract_errors(body)
      return if body.empty?
      errors = Array.wrap(body["errors"]["error"])
    end
    
  end
  
end
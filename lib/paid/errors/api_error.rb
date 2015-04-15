module Paid
  class APIError < PaidError
    attr_reader :api_method

    def initialize(message=nil, api_method=nil)
      @message = message
      @api_method = api_method
    end

    def code
      @api_method.response_code if @api_method
    end

    def body
      @api_method.response_body if @api_method
    end

    def json
      begin
        @api_method.response_json if @api_method
      rescue APIError
        nil
      end
    end

    def to_s
      prefix = code.nil? ? "" : "(Status #{code}) "
      "#{prefix}#{@message}"
    end
  end
end


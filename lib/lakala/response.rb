# frozen_string_literal: true

module Lakala
  class Response
    attr_reader :net_http_response,
                :body,
                :code

    def initialize(res)
      @net_http_response = res
      @body = JSON.parse(res.body&.dup&.force_encoding('UTF-8'))
      @code = res.code
    end

    def success?
      !failed?
    end

    def failed?
      @net_http_response.code != '200'
    end

    def error_code
      @body['code'] if failed?
    end

    def error_msg
      @body['msg'] if failed?
    end
  end
end

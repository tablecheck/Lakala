# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require 'base64'
require 'openssl'
require 'pry'
require 'uri'
require 'net/http'
require 'json'

require 'lakala/configuration'
require 'lakala/client'
require 'lakala/sign'
require 'lakala/utils'
require 'lakala/response'

module Lakala
  GATEWAY_URL = 'https://s2.lakala.com/'
  SANDBOX_GATEWAY_URL = 'https://test.wsmsd.cn/sit'

  attr_accessor :app_id, :serial_no, :private_key, :public_key, :sandbox_mode, :configuration

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def gateway_url
      return SANDBOX_GATEWAY_URL if Lakala.configuration.sandbox_mode

      GATEWAY_URL
    end
  end
end

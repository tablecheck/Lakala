# frozen_string_literal: true

module Lakala
  class HeaderGenerator
    def initialize(params, serial_no = nil)
      @serial_no = serial_no || config.serial_no
      @params = params
    end

    def generate
      nonce_str = Lakala::Utils.nonce_str

      auth_string = "appid='#{config.app_id}'," \
                    "serial_no='#{@serial_no}'," \
                    "nonce_str='#{nonce_str}'," \
                    "timestamp='#{Time.now.to_i}'," \
                    "signature='#{Lakala::Sign.generate(@params, nonce_str)}'"

      {
        'Content-Type' => 'application/json',
        'Authorization' => "LKLAPI-SHA256withRSA #{auth_string}"
      }
    end

    private

    def config
      Lakala.configuration
    end
  end
end

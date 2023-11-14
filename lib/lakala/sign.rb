# frozen_string_literal: true

module Lakala
module Sign
  class << self
    def string_to_verify(response_headers, response_body)
      lkl_app_id = response_headers['Lklapi-Appid']
      lkl_serial_no = response_headers['Lklapi-Serial']
      lkl_timestamp = response_headers['Lklapi-Timestamp']
      lkl_nonce_str = response_headers['Lklapi-Nonce']

      "#{lkl_app_id}\n#{lkl_serial_no}\n#{lkl_timestamp}\n#{lkl_nonce_str}\n#{response_body}\n"
    end

    def generate(request_body)
      timestamp = Time.now.to_i
      nonce_str = Lakala::Utils.nonce_str

      string_to_sign = "#{Lakala.configuration.app_id}\n" \
                       "#{Lakala.configuration.serial_no}\n" \
                       "#{timestamp}\n" \
                       "#{nonce_str}\n" \
                       "#{{ 'reqData' => request_body }}\n"

      signed_string = Lakala.configuration.private_key.sign(OpenSSL::Digest.new('SHA256'), string_to_sign)

      Base64.strict_encode64(signed_string)
    end

    def verify?(headers, body)
      data_to_verify = Lakala::Sign.string_to_verify(headers, body)
      signature = Base64.strict_decode64(headers['Lklapi-Signature'])

      Lakala.configuration.private_key.verify(OpenSSL::Digest.new('SHA256'), signature, data_to_verify)
    end
  end
end
end

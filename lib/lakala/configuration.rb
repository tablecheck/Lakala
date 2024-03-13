# frozen_string_literal: true

module Lakala
  class Configuration
    attr_accessor :app_id,
                  :serial_no,
                  :sandbox_mode

    attr_reader   :private_key,
                  :public_key,
                  :cypher_key

    def private_key=(private_key)
      @private_key = OpenSSL::PKey::RSA.new(private_key)
    end

    def public_key=(public_key)
      @private_key = OpenSSL::X509::Certificate.new(public_key).public_key
    end

    def cypher_key=(cypher_key)
      @cypher_key = Base64.strict_decode64(cypher_key)
    end

  end
end

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
    rescue OpenSSL::PKey::RSAError
      log_warning('Invalid private key for Lakala')
    end

    def public_key=(public_key)
      @public_key = OpenSSL::X509::Certificate.new(public_key).public_key
    rescue OpenSSL::X509::CertificateError
      log_warning('Invalid public key for Lakala')
    end

    def cypher_key=(cypher_key)
      if cypher_key.empty?
        log_warning('[WARNING] Cypher Key is missing')
      else
        @cypher_key = Base64.strict_decode64(cypher_key)
      end
    end

    private

    def log_warning(message)
      if defined?(Rails) && Rails.logger
        Rails.logger.warn(message)
      else
        puts "[WARNING] #{message}"
      end
    end
  end
end

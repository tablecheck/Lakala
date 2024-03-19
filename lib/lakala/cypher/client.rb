# frozen_string_literal: true

module Lakala
module Cypher
  class Client
    ALGORITHM_NAME_ECB_PADDING = 'sm4-ecb'

    def encrypt(data)
      encrypted_data = encrypt_ecb_padding(data)
      Base64.strict_encode64(encrypted_data)
    end

    def decrypt(cipher_text)
      decrypted_data = decrypt_ecb_padding(Base64.strict_decode64(cipher_text))
      decrypted_data.force_encoding('utf-8')
    end

    private

    def encrypt_ecb_padding(data)
      cipher = OpenSSL::Cipher.new(ALGORITHM_NAME_ECB_PADDING)
      cipher.encrypt
      cipher.key = ::Lakala.configuration.cypher_key
      cipher.update(data) + cipher.final
    end

    def decrypt_ecb_padding(cipher_text)
      cipher = OpenSSL::Cipher.new(ALGORITHM_NAME_ECB_PADDING)
      cipher.decrypt
      cipher.key = ::Lakala.configuration.cypher_key
      cipher.update(cipher_text) + cipher.final
    end
  end
end
end

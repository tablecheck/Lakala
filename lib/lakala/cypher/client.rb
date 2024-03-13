# frozen_string_literal: true

module Lakala
module Cypher
  class Client
    ALGORITHM_NAME_ECB_PADDING = 'sm4-ecb'

    def encrypt(data)
      encrypted_data = encrypt_ECB_Padding(data)
      Base64.strict_encode64(encrypted_data)
    end

    def decrypt(cipher_text)
      decrypted_data = decrypt_ECB_Padding(Base64.strict_decode64(cipher_text))
      decrypted_data.force_encoding('utf-8')
    end

    private

    def encrypt_ECB_Padding(data)
      cipher = OpenSSL::Cipher.new(ALGORITHM_NAME_ECB_PADDING)
      cipher.encrypt
      cipher.key = ::Lakala.configuration.cypher_key
      cipher.update(data) + cipher.final
    end

    def decrypt_ECB_Padding(cipher_text)
      cipher = OpenSSL::Cipher.new(ALGORITHM_NAME_ECB_PADDING)
      cipher.decrypt
      cipher.key = ::Lakala.configuration.cypher_key
      cipher.update(cipher_text) + cipher.final
    end
  end
end
end

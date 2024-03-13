# frozen_string_literal: true

require 'spec_helper'
require 'openssl'

RSpec.describe Lakala::Cypher::Client do
  let(:service) { Lakala::Cypher::Client.new }

  describe do
    let(:data) { '123456' }

    before :each do
      Lakala.configure do |config|
        config.app_id = 'OP00000003'
        config.serial_no = '00dfba8194c41b84cf'
        config.sandbox_mode = true
        config.private_key = OpenSSL::PKey::RSA.new(2048).to_pem
        config.cypher_key = '0I4M0kmwFrNUU8hZ9AFpfA=='
      end
    end

    it do
      encrypted_data = service.encrypt(data)
      expect(encrypted_data).to eq('H6Gl8nFSb4IFoKRKg2MaZg==')
    end

    it do
      encrypted_data = 'H6Gl8nFSb4IFoKRKg2MaZg=='
      decrypted_data = service.decrypt(encrypted_data)
      expect(decrypted_data).to eq('123456')
    end
  end
end

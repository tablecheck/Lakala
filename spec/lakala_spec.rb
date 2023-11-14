# frozen_string_literal: true

RSpec.describe Lakala do
  describe '#attr_accessor' do
    let(:private_key) do
<<-EOF
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxqt6Y4wOcTHeLCgO9Dw+
nVg4+A9FiJcHwjTYY+OGl80UVbP7r/3ytjoGykPa1dx77QVF/3/W0fyMk82FVJBW
5HWZhIHSXvk6GV8mpVMx4YO3Q55uvGBap3LnR4YUUnj2ZOJFF3ZzyeOTO6X43qX1
6CJbduP5pceGwcS1wEbtqXbCrikESyDvCMW5tNk3pcq8SJvaAM73d0PODRqdTtAy
BhAMiGVXBLQUrfuA6p//6McIltDe/U7e5kDFdGMLyJ38/lypeQUqrbZwc+dWD1Es
7hdBlmDc4igxIpHfCFVcWyp7vPdlucStpEsJ4KwB2j0PyKt71nbTY9y9xY6PSzGq
HwIDAQAB
-----END PUBLIC KEY-----
EOF
    end

    let(:public_key) do
<<-EOF
-----BEGIN CERTIFICATE-----
MIIDoDCCAoigAwIBAgIGAYu4QKeJMA0GCSqGSIb3DQEBBQUAMGAxFDASBgNVBAMM
C0xBS0FMQS1MQU9QMQswCQYDVQQGEwJDTjEXMBUGA1UECgwOTGFrYWxhIENvLixM
dGQxDzANBgNVBAsMBkxLTC1ZRjERMA8GA1UEBwwIc2hhbmdoYWkwHhcNMjMxMTEw
MDgwMjA2WhcNMzMxMTEwMDgwMjA2WjBgMRQwEgYDVQQDDAtMQUtBTEEtTEFPUDEL
MAkGA1UEBhMCQ04xFzAVBgNVBAoMDkxha2FsYSBDby4sTHRkMQ8wDQYDVQQLDAZM
S0wtWUYxETAPBgNVBAcMCHNoYW5naGFpMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxqt6Y4wOcTHeLCgO9Dw+nVg4+A9FiJcHwjTYY+OGl80UVbP7r/3y
tjoGykPa1dx77QVF/3/W0fyMk82FVJBW5HWZhIHSXvk6GV8mpVMx4YO3Q55uvGBa
p3LnR4YUUnj2ZOJFF3ZzyeOTO6X43qX16CJbduP5pceGwcS1wEbtqXbCrikESyDv
CMW5tNk3pcq8SJvaAM73d0PODRqdTtAyBhAMiGVXBLQUrfuA6p//6McIltDe/U7e
5kDFdGMLyJ38/lypeQUqrbZwc+dWD1Es7hdBlmDc4igxIpHfCFVcWyp7vPdlucSt
pEsJ4KwB2j0PyKt71nbTY9y9xY6PSzGqHwIDAQABo2AwXjAPBgNVHRMECDAGAQH/
AgEAMB8GA1UdIwQYMBaAFMgt1WuNqN0HI+qz6de5BPhHuCx9MB0GA1UdDgQWBBTI
LdVrjajdByPqs+nXuQT4R7gsfTALBgNVHQ8EBAMCBsAwDQYJKoZIhvcNAQEFBQAD
ggEBAIBhE7zINbm8+859aAKBbybrEL256pWmEDoTO2lf5POg/wEjdfEiNgGpSz8R
cVbSwGsKXP00cKN7RpvCt/m+2bmz+IgLDJS5/qRN3GGG355ezYlHMBpQGrB4jsXX
hhNTjRn6Gj0tTfn9jfDcVOa3UiHS67FPI/SAl1ZvjHTuMAPcT9kIPsHwEQt+heOS
5toRuV7fpI4YXINK/mJ1GzzyssrXiO/aNbqzf9k0bD2FIuQtwGabMIhbgFEpWL7s
tVryCgEBt4VkZFphYLPEFLTYqr3O1l3DxRjVOidoJVMabPQTfvyZ3TVPEXU6VMxE
eXY0CgyZYxN6lqfxgkoZGTJJ/Co=
-----END CERTIFICATE-----
EOF
    end

    it do
      Lakala.configure do |config|
        config.app_id = '123'
        config.serial_no = '456'
        config.private_key = private_key
        config.public_key = public_key
        config.sandbox_mode = true
      end

      expect(Lakala.configuration.app_id).to eq '123'
      expect(Lakala.configuration.serial_no).to eq '456'
      expect(Lakala.configuration.private_key).to_not be_nil
      expect(Lakala.configuration.public_key).to_not be_nil
      expect(Lakala.configuration.sandbox_mode).to be_truthy
    end
  end
end

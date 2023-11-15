# frozen_string_literal: true

module Lakala
  class Client
    attr_reader :response

    def create_order(options = {})
      options = Lakala::Utils.stringify_keys(options)
      requires!(options, %w[out_order_no merchant_no total_amount order_info order_efficient_time])

      response = req('/api/v3/ccss/counter/order/create', options)

      Response.new(response)
    end

    private

    def prepared_params(request_body)
      {
        req_data: request_body,
        version: '3.0',
        req_time: Time.now.strftime('%Y%m%d%H%M%S')
      }
    end

    def config
      Lakala.configuration
    end

    def req(path, body)
      uri = URI.parse("#{Lakala.gateway_url}#{path}")
      uri.scheme = 'https' # Set the URI scheme to HTTPS
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      prepared_params = prepared_params(body).to_json

      headers = generate_authorization_header(prepared_params)

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = prepared_params
      request.content_type = 'application/json'

      http.request(request)
    end

    def requires!(options, required_opts)
      required_opts.each do |f|
        raise "Missing required argument: #{f}" if options[f].nil? && !options[f]&.to_s&.empty? && options[f] != false
      end
    end

    def generate_authorization_header(params)
      auth_string = "appid='#{config.app_id}'," \
                    "serial_no='#{config.serial_no}'," \
                    "nonce_str='#{Lakala::Utils.nonce_str}'," \
                    "timestamp='#{Time.now.to_i}'," \
                    "signature='#{Lakala::Sign.generate(params)}'"

      {
        'Content-Type' => 'application/json',
        'Authorization' => "LKLAPI-SHA256withRSA #{auth_string}"
      }
    end
  end
end

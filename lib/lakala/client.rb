# frozen_string_literal: true

module Lakala
  class Client
    attr_reader :response

    def create_order(options = {})
      options = Lakala::Utils.stringify_keys(options)
      requires!(options, %w[out_order_no merchant_no total_amount order_info order_efficient_time])

      response = req('/sit/api/v3/ccss/counter/order/create', options)

      Response.new(response)
    end

    def query_order(options)
      options = Lakala::Utils.stringify_keys(options)
      if options['out_order_no'].nil?
        requires!(options, %w[pay_order_no channel_id])
      else
        requires!(options, %w[merchant_no out_order_no])
      end

      response = req('/sit/api/v3/ccss/counter/order/query', options)

      Response.new(response)
    end

    def refund(options)
      options = Lakala::Utils.stringify_keys(options)
      requires!(options, %w[merchant_no term_no out_trade_no refund_amount request_ip])
      requires_at_least_one!(options, %w[origin_out_trade_no origin_trade_no origin_log_no])

      opts = {
        'location_info' => {
          'request_ip' => options['request_ip'],
          'location' => options['geo_location'],
          'base_station' => options['base_station']
        }
      }.compact
      options.merge!(opts)

      response = req('/sit/api/v3/labs/relation/refund', options)

      Response.new(response)
    end

    def query_refund_order(options)
      options = Lakala::Utils.stringify_keys(options)

      requires!(options, %w[merchant_no term_no out_refund_order_no])

      response = req('/sit/api/v3/labs/query/idmrefundquery', options)

      Response.new(response)
    end

    private

    def prepare_params(request_body)
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
      uri = build_uri(path)
      http = build_http(uri)
      prepared_params = prepare_params(body).to_json
      headers = generate_authorization_header(prepared_params)

      request = build_post_request(uri, headers, prepared_params)

      http.request(request)
    end

    def requires!(options, required_opts)
      required_opts.each do |f|
        raise "Missing required argument: #{f}" if options[f].nil? && !options[f]&.to_s&.empty? && options[f] != false
      end
    end

    def requires_at_least_one!(options, required_opts)
      return unless required_opts.none? { |f| options.key?(f) && !options[f]&.to_s&.empty? && options[f] != false }

      raise "At least one of the options is required: #{required_opts.join(', ')}"
    end

    def generate_authorization_header(params)
      nonce_str = Lakala::Utils.nonce_str

      auth_string = "appid='#{config.app_id}'," \
                    "serial_no='#{config.serial_no}'," \
                    "nonce_str='#{nonce_str}'," \
                    "timestamp='#{Time.now.to_i}'," \
                    "signature='#{Lakala::Sign.generate(params, nonce_str)}'"

      {
        'Content-Type' => 'application/json',
        'Authorization' => "LKLAPI-SHA256withRSA #{auth_string}"
      }
    end

    def build_uri(path)
      uri = URI.parse("#{Lakala.gateway_url}#{path}")
      uri.scheme = 'https'
      uri
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http
    end

    def build_post_request(uri, headers, prepared_params)
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = prepared_params
      request.content_type = 'application/json'
      request
    end
  end
end

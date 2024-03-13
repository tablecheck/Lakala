# frozen_string_literal: true

module Lakala
  class Client
    attr_reader :response

    def initialize(serial_no = nil)
      @serial_no = serial_no || config.serial_no
    end

    def create_order(options = {})
      options = Lakala::Utils.stringify_keys(options)

      requires!(options, %w[out_order_no merchant_no total_amount order_info order_efficient_time])

      raise ArgumentError, 'total_amount must be a positive integer' unless options['total_amount'].is_a?(Integer) && options['total_amount'] > 0

      response = req('/api/v3/ccss/counter/order/create', options)

      Response.new(response)
    end

    def create_order_enc(options = {})
      options = Lakala::Utils.stringify_keys(options)

      requires!(options, %w[out_order_no merchant_no total_amount order_info order_efficient_time])

      raise ArgumentError, 'total_amount must be a positive integer' unless options['total_amount'].is_a?(Integer) && options['total_amount'] > 0

      response = req('/api/v3/ccss/counter/order/create_encry', options, encrypt: true)

      Response.new(response)
    end

    def query_order(options)
      options = Lakala::Utils.stringify_keys(options)
      if options['out_order_no'].nil?
        requires!(options, %w[pay_order_no channel_id])
      else
        requires!(options, %w[merchant_no out_order_no])
      end

      response = req('/api/v3/ccss/counter/order/query', options)

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

      response = req('/api/v3/labs/relation/refund', options)

      Response.new(response)
    end

    def query_refund_order(options)
      options = Lakala::Utils.stringify_keys(options)

      requires!(options, %w[merchant_no term_no out_refund_order_no])

      response = req('/api/v3/labs/query/idmrefundquery', options)

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

    def req(path, body, encrypt: false)
      uri = build_uri(path)
      http = build_http(uri)

      prepared_body = prepare_params(body).to_json

      request_body = encrypt ? encrypt(prepared_body) : prepared_body

      headers = generate_authorization_header(request_body)


      request = build_post_request(uri, headers, request_body)

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
      Lakala::HeaderGenerator.new(params, @serial_no).generate
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

    def encrypt(data)
      ::Lakala::Cypher::Client.new(data).encrypt
    end
  end
end

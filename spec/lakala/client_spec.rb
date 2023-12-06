# frozen_string_literal: true

require 'spec_helper'
require 'openssl'

RSpec.describe Lakala::Client do
  before :each do
    Lakala.configure do |config|
      config.app_id = 'OP00000003'
      config.serial_no = '00dfba8194c41b84cf'
      config.sandbox_mode = true
      config.private_key = OpenSSL::PKey::RSA.new(2048).to_pem
    end
  end

  context '#create_order' do
    let(:res) do
      {
        'msg': '操作成功',
        'resp_time': '20210922181057',
        'code': '000000',
        'resp_data': {
          'merchant_no': '8222900701106PZ',
          'channel_id': '25',
          'out_order_no': 'KFPT20220714160009228907288',
          'order_create_time': '20210922181056',
          'order_efficient_time': '20210803141700',
          'pay_order_no': '21092211012001970631000488056',
          'counter_url': 'http://q.huijingcai.top/b/pay?merchantNo=8221210594300JY&merchantOrderNo=08F4542EEC6A4497BC419161747A92FQ&payOrderNo=21092211012001970631000488056'
        }
      }
    end

    before do
      WebMock.stub_request(:post, 'https://test.wsmsd.cn/sit/api/v3/ccss/counter/order/create')
             .to_return(status: 200, body: res.to_json, headers: { 'Content-Type' => 'application/json' })
    end
    it do
      result = Lakala::Client.new.create_order(
        merchant_no: '8221210594300JY',
        out_order_no: 'aa3c56712',
        total_amount: 200,
        order_info: 'Test Product',
        order_efficient_time: '20231113163310'
      )

      expect(result).to be_a(Lakala::Response)
      expect(result.success?).to be_truthy
    end
  end

  context '#query_order' do
    let(:res) do
      {
        'msg': '操作成功',
        'resp_time': '20210922174806',
        'code': '000000',
        'resp_data': {
          'pay_order_no': '21092211012001970631000488042',
          'out_order_no': 'LABS1632300253YDMG',
          'channel_id': '15',
          'trans_merchant_no': '82216205947000G',
          'trans_term_no': 'D0060389',
          'merchant_no': '82216205947000G',
          'term_no': 'D0060389',
          'order_status': '2',
          'order_info': '24865454154',
          'total_amount': 3300,
          'order_create_time': '20210922164413',
          'order_efficient_time': '20221208165845',
          'order_trade_info_list': [
            {
              'trade_no': '2021092251210203410010',
              'log_No': '51210203410010',
              'trade_type': 'PAY',
              'trade_status': 'S',
              'trade_amount': 3300,
              'payer_amount': 0,
              'user_id1': '',
              'user_id2': '',
              'busi_type': 'ONLINE',
              'trade_time': '2021092264452',
              'acc_trade_no': '109221009853',
              'payer_account_no': '',
              'payer_name': '',
              'payer_account_bank': '',
              'acc_type': '99',
              'pay_mode': 'LKLAT'
            }
          ]
        }
      }
    end

    before do
      WebMock.stub_request(:post, 'https://test.wsmsd.cn/sit/api/v3/ccss/counter/order/query')
             .to_return(status: 200, body: res.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it do
      result = Lakala::Client.new.query_order(merchant_no: '8221210594300JY', out_order_no: 'aa3c56712')
      expect(result).to be_a(Lakala::Response)
      expect(result.success?).to be_truthy
    end
  end
end

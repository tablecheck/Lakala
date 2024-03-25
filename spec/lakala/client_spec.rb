# frozen_string_literal: true

require 'spec_helper'
require 'openssl'

RSpec.describe Lakala::Client do
  describe 'Lakala requests' do
    before :each do
      Lakala.configure do |config|
        config.app_id = 'OP00000003'
        config.serial_no = '00dfba8194c41b84cf'
        config.cypher_key = '0I4M0kmwFrNUU8hZ9AFpfA=='
        config.sandbox_mode = true
        config.private_key = OpenSSL::PKey::RSA.new(2048).to_pem
      end

      WebMock.stub_request(:post, url)
             .to_return(status: 200, body: res.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    describe '#create_order' do
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

      context 'with encryption' do
        let(:url) { 'https://test.wsmsd.cn/sit/api/v3/ccss/counter/order/create_encry' }

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

      context 'without encryption' do
        let(:url) { 'https://test.wsmsd.cn/sit/api/v3/ccss/counter/order/create' }

        it do
          result = Lakala::Client.new.create_order(
            encryption: false,
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
    end

    context '#query_order' do
      let(:url) { 'https://test.wsmsd.cn/sit/api/v3/ccss/counter/order/query' }
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

      it do
        result = Lakala::Client.new.query_order(merchant_no: '8221210594300JY', out_order_no: 'aa3c56712')
        expect(result).to be_a(Lakala::Response)
        expect(result.success?).to be_truthy
      end
    end

    context '#refund' do
      let(:url) { 'https://test.wsmsd.cn/sit/api/v3/labs/relation/refund' }
      let(:res) do
        { 'msg': '成功',
          'resp_time': '20210907173417',
          'code': 'BBS00000',
          'resp_data': {
            'out_refund_order_no': 'wxy2021090700003',
            'trade_no': '2021090766160003670036',
            'log_no': '66160003670036',
            'acc_trade_no': '2021090722001449261431458662',
            'account_type': 'ALIPAY',
            'total_amount': '1',
            'refund_amount': '1',
            'payer_amount': '1',
            'trade_time': '20210907173417',
            'origin_trade_no': '2021090766210003670031',
            'origin_out_trade_no': 'wxy2021090700001',
            'up_iss_addn_data': '',
            'up_coupon_info': '',
            'trade_info': ''
          } }
      end

      it do
        result = Lakala::Client.new.refund(
          merchant_no: '8221210594300JY',
          geo_location: '30.700323750778548, 104.0029400018854',
          request_ip: '222.209.111.239',
          refund_amount: 1,
          term_no: 'A0073841',
          out_trade_no: 'aa3c56723123',
          origin_trade_no: '2023120866210311384863'
        )

        expect(result).to be_a(Lakala::Response)
        expect(result.success?).to be_truthy
      end

      it 'should raise error' do
        expect do
          Lakala::Client.new.refund(
            merchant_no: '8221210594300JY',
            geo_location: '30.700323750778548, 104.0029400018854',
            request_ip: '222.209.111.239',
            refund_amount: 1,
            term_no: 'A0073841',
            out_trade_no: 'aa3c56723123'
          )
        end.to raise_error('At least one of the options is required: origin_out_trade_no, origin_trade_no, origin_log_no')
      end
    end

    context '#query_refund_order' do
      let(:url) { 'https://test.wsmsd.cn/sit/api/v3/labs/query/idmrefundquery' }
      let(:res) do
        {
          'msg': '成功',
          'resp_time': '20210907160309',
          'code': 'BBS00000',
          'resp_data': {
            'out_trade_no': 'FD660E1FAA3A4470933CDEDAE1EC1D8E',
            'trade_no': '2021090766210003630077',
            'log_no': '66210003630077',
            'acc_trade_no': '4200001212202109078945008028',
            'account_type': 'WECHAT',
            'settle_term_no': '',
            'trade_state': 'SUCCESS',
            'trade_state_desc': '交易成功',
            'total_amount': '123',
            'payer_amount': '123',
            'acc_settle_amount': '123',
            'acc_mdiscount_amount': '0',
            'acc_discount_amount': '',
            'trade_time': '20210907150327',
            'user_id1': 'olpr-0kUcyJIbVhYmAsBvoZuB4TI',
            'user_id2': 'oUpF8uE150tsN4W00ieTusZcK70s',
            'bank_type': 'CMB_CREDIT',
            'acc_activity_id': '',
            'up_coupon_info': '',
            'trade_info': ''
          }
        }
      end

      it do
        result = Lakala::Client.new.query_refund_order(
          merchant_no: '8221210594300JY',
          term_no: '123',
          out_refund_order_no: 'wxy2021090700003',
          refund_amount: 100_00,
          geo_location: '+37.123456789,-121.123456789',
          request_ip: '0.0.0.0'
        )

        expect(result).to be_a(Lakala::Response)
        expect(result.success?).to be_truthy
      end
    end
  end
end

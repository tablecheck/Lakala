# Lakala

Lakala Ruby client with some basic features for Lakala APIs.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add lakala

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install lakala

## Usage

``` ruby
# Create order -> http://open.lakala.com/#/home/document/detail?id=283
options = {
            merchant_no: '8221210594300JY',
            out_order_no: 'aa3c56712',
            total_amount: 200,
            order_info: 'Test Product',
            order_efficient_time: '20231113163310'
          }
Lakala::Client.new.create_order(options)
# or without encryption
Lakala::Client.new.create_order(options, encryption: false)

# Query order -> http://open.lakala.com/#/home/document/detail?id=284
Lakala::Client.new.query_order(merchant_no: '8221210594300JY', out_order_no: 'aa3c56712')

# Invoke refund -> http://open.lakala.com/#/home/document/detail?id=113
Lakala::Client.new.refund(
  merchant_no: '8221210594300JY',
  geo_location: '30.700323750778548, 104.0029400018854',
  request_ip: '222.209.111.239',
  refund_amount: 1,
  term_no: 'A0073841',
  out_trade_no: 'aa3c56723123',
  origin_trade_no: '2023120866210311384863'
)
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

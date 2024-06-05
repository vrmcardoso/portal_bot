# app/services/bybit_api_service.rb
require 'httparty'

class BybitApiService
  include HTTParty
  base_uri 'https://api.bybit.com'

  def initialize(api_key, api_secret)
    @api_key = api_key
    @api_secret = api_secret
  end

  def get_kline(symbol, interval, start_time, end_time)
    options = {
      query: {
        symbol: symbol,
        interval: interval,
        from: start_time,
        to: end_time
      }
    }
    self.class.get('/v2/public/kline/list', options)
  end

  # Add more methods to interact with Bybit API as needed
end

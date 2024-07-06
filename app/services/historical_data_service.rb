# app/services/historical_data_service.rb
require 'faraday'
require 'json'

class HistoricalDataService
  BASE_URI = 'https://api.bybit.com'
  RATE_LIMIT = 600
  RATE_LIMIT_WINDOW = 5 # seconds

  def initialize
    @connection = Faraday.new(url: BASE_URI)
    @requests_made = 0
    @window_start_time = Time.now
  end

  def fetch(symbol, interval, from, to)
    all_data = []
    current_from = from

    loop do
      reset_rate_limit_window_if_needed

      if @requests_made >= RATE_LIMIT
        sleep_remaining_window_time
        reset_rate_limit_window
      end

      response = @connection.get('/v5/market/kline', {
        symbol: symbol,
        interval: interval,
        start: current_from,
        end: to,
        limit: 200 # Assuming 200 is the max limit per request
      })

      if response.status == 429
        puts "Rate limit exceeded. Waiting for #{RATE_LIMIT_WINDOW} seconds."
        sleep RATE_LIMIT_WINDOW
        reset_rate_limit_window
        next
      end

      raise "Failed to fetch data: #{response.reason_phrase}" unless response.success?

      data = JSON.parse(response.body)['result']['list']
      break if data.empty?

      all_data.concat(data)
      current_from = data.last[0].to_i + 1 # Adjust for the next batch

      break if current_from >= to

      @requests_made += 1

      # Introduce a small sleep to ensure we don't hammer the API too quickly
      sleep (RATE_LIMIT_WINDOW.to_f / RATE_LIMIT).ceil
    end

    all_data
  end

  def fetch_multiple_intervals(symbol, intervals, from, to)
    intervals.each_with_object({}) do |interval, data|
      data[interval] = fetch(symbol, interval, from, to)
    end
  end

  private

  def reset_rate_limit_window_if_needed
    if Time.now - @window_start_time >= RATE_LIMIT_WINDOW
      reset_rate_limit_window
    end
  end

  def reset_rate_limit_window
    @requests_made = 0
    @window_start_time = Time.now
  end

  def sleep_remaining_window_time
    time_passed = Time.now - @window_start_time
    if time_passed < RATE_LIMIT_WINDOW
      sleep RATE_LIMIT_WINDOW - time_passed
    end
  end
end

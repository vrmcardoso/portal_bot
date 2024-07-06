class HistoricalDataService
  include HTTParty
  base_uri 'https://api.bybit.com'

  def fetch(symbol, interval, from, to)
    response = self.class.get("/v2/public/kline/list", query: {
      symbol: symbol,
      interval: interval,
      from: from,
      to: to
    })
    JSON.parse(response.body)['result']
  end

  def fetch_multiple_intervals(symbol, intervals, from, to)
    intervals.each_with_object({}) do |interval, data|
      data[interval] = fetch(symbol, interval, from, to)
    end
  end
end

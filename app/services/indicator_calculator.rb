class IndicatorCalculator
  def self.calculate_stochastic_rsi(data, period: 14, k_period: 3, d_period: 3)
    data.each_with_index do |candle, index|
      next if index < period - 1

      high = data[(index - period + 1)..index].max_by { |d| d[:high] }[:high]
      low = data[(index - period + 1)..index].min_by { |d| d[:low] }[:low]
      close = candle[:close]

      k_value = 100 * (close - low) / (high - low)
      candle[:stochastic_rsi_k] = k_value
    end

    data.each_with_index do |candle, index|
      next if index < period + k_period - 2

      k_values = data[(index - k_period + 1)..index].map { |d| d[:stochastic_rsi_k] }
      candle[:stochastic_rsi_d] = k_values.sum / k_period
    end

    data
  end

  def self.calculate_macd(data, fast_period: 12, slow_period: 26, signal_period: 9)
    fast_ema = calculate_ema(data.map { |c| c[:close] }, fast_period)
    slow_ema = calculate_ema(data.map { |c| c[:close] }, slow_period)
    macd = fast_ema.zip(slow_ema).map { |f, s| f - s }
    signal_line = calculate_ema(macd, signal_period)

    data.each_with_index do |candle, index|
      candle[:macd] = macd[index]
      candle[:signal_line] = signal_line[index]
    end

    data
  end

  def self.calculate_ema(data, period)
    k = 2.0 / (period + 1)
    ema = []

    data.each_with_index do |price, index|
      if index == 0
        ema << price
      else
        ema << (price * k + ema.last * (1 - k))
      end
    end

    ema
  end
end

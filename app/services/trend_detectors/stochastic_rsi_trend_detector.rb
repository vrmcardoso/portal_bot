class StochasticRsiTrendDetector
  def initialize(daily_data, weekly_data)
    @daily_data = daily_data
    @weekly_data = weekly_data
  end

  def detect_trend_at(timestamp)
    daily_candle = @daily_data.find { |candle| candle[:timestamp] <= timestamp }
    weekly_candle = @weekly_data.find { |candle| candle[:timestamp] <= timestamp }

    return :sideways unless daily_candle && weekly_candle

    daily_trend = calculate_stochastic_rsi_trend(daily_candle)
    weekly_trend = calculate_stochastic_rsi_trend(weekly_candle)

    if weekly_trend == :bullish && daily_trend == :bullish
      :uptrend
    elsif weekly_trend == :bearish && daily_trend == :bearish
      :downtrend
    else
      :sideways
    end
  end

  private

  def calculate_stochastic_rsi_trend(candle)
    if candle[:stochastic_rsi_k] > candle[:stochastic_rsi_d]
      :bullish
    elsif candle[:stochastic_rsi_k] < candle[:stochastic_rsi_d]
      :bearish
    else
      :sideways
    end
  end
end

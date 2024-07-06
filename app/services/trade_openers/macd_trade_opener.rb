class MacdTradeOpener < BaseTradeOpener
  def entry_condition_met?(previous_candle, current_candle, trend)
    rule = @strategy_config['entry_rules'][trend.to_s]

    if rule['condition'] == 'bullish_cross' && trend == :uptrend
      previous_candle[:macd] < previous_candle[:signal_line] &&
      current_candle[:macd] > current_candle[:signal_line]
    elsif rule['condition'] == 'bearish_cross' && trend == :downtrend
      previous_candle[:macd] > previous_candle[:signal_line] &&
      current_candle[:macd] < current_candle[:signal_line]
    else
      false
    end
  end
end

class OneToOneTradeCloser
  def initialize(candle, percentage_difference)
    super(candle)
    @percentage_difference = percentage_difference
  end

  def calculate_stop_loss
    @candle['close'] * (1 - @percentage_difference / 100.0)
  end

  def calculate_take_profit
    @candle['close'] * (1 + @percentage_difference / 100.0)
  end
end

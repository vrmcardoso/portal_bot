class StrategyRunner
  def initialize(strategy_name, data)
    @strategy_config = load_strategy_config(strategy_name)
    @data = data
    @trend_detector = initialize_component(@strategy_config['trend_detector'], data['1d_stochastic_rsi'], data['1w_stochastic_rsi'])
    @trade_opener = initialize_component(@strategy_config['trade_opener'])
    @trade_closer_config = @strategy_config['trade_closer']
    @open_trades = []
    @closed_trades = []
  end

  def execute
    @data['1h'].each_cons(2) do |previous_candle, current_candle|
      trend = @trend_detector.detect_trend_at(current_candle[:timestamp])
      process_open_trades(current_candle)
      if @trade_opener.entry_condition_met?(previous_candle, current_candle, trend)
        open_trade(current_candle)
      end
    end

    # Close any remaining open trades at the end of the data
    @open_trades.each { |trade| close_trade(trade, @data['1h'].last) }

    @closed_trades
  end

  private

  def load_strategy_config(strategy_name)
    strategies = YAML.load_file(Rails.root.join('config', 'strategies.yml'))['strategies']
    strategies[strategy_name]
  end

  def initialize_component(class_name, *args)
    Object.const_get(class_name).new(*args)
  end

  def open_trade(candle)
    trade_closer = initialize_component(@trade_closer_config['class'], candle, @trade_closer_config['parameters']['percentage_difference'])
    @open_trades << {
      entry: candle['close'],
      stop_loss: trade_closer.calculate_stop_loss,
      take_profit: trade_closer.calculate_take_profit,
      entry_time: candle['timestamp'],
      side: determine_side(candle),
      trading_pair_id: candle['trading_pair_id'],
      quantity: determine_quantity(candle),
      fees: calculate_fees(candle),
      trade_duration: calculate_trade_duration(candle)
    }
  end

  def process_open_trades(current_candle)
    @open_trades.each do |trade|
      if current_candle['low'] <= trade[:stop_loss]
        close_trade(trade, current_candle, trade[:stop_loss])
      elsif current_candle['high'] >= trade[:take_profit]
        close_trade(trade, current_candle, trade[:take_profit])
      end
    end

    @open_trades.reject! { |trade| trade[:closed] }
  end

  def close_trade(trade, candle, exit_price = nil)
    exit_price ||= candle['close']
    profit_loss = exit_price - trade[:entry]
    trade[:exit] = exit_price
    trade[:exit_time] = candle['timestamp']
    trade[:profit_loss] = profit_loss
    trade[:closed] = true

    @closed_trades << trade
  end

  def determine_side(candle)
    # Determine the side (long or short) based on your strategy
  end

  def determine_quantity(candle)
    # Determine the quantity based on your strategy
  end

  def calculate_fees(candle)
    # Calculate the fees based on your strategy
  end

  def calculate_trade_duration(candle)
    # Calculate the trade duration based on your strategy
  end
end

class BacktestsController < ApplicationController
  def new
    @backtest = Backtest.new
  end

  def create
    trading_pair_id = params[:backtest][:trading_pair_id]
    trading_pair = TradingPair.find(trading_pair_id)
    from_date = Date.new(params[:backtest]["from(1i)"].to_i, params[:backtest]["from(2i)"].to_i, params[:backtest]["from(3i)"].to_i)
    to_date = Date.new(params[:backtest]["to(1i)"].to_i, params[:backtest]["to(2i)"].to_i, params[:backtest]["to(3i)"].to_i)
    from = from_date.to_time.to_i
    to = to_date.to_time.to_i

    historical_data_service = HistoricalDataService.new
    data = historical_data_service.fetch_multiple_intervals(trading_pair.symbol, ['1h', '1d', '1w'], from, to)

    data['1d_stochastic_rsi'] = IndicatorCalculator.calculate_stochastic_rsi(data['1d'])
    data['1d_macd'] = IndicatorCalculator.calculate_macd(data['1d'])
    data['1w_stochastic_rsi'] = IndicatorCalculator.calculate_stochastic_rsi(data['1w'])
    data['1w_macd'] = IndicatorCalculator.calculate_macd(data['1w'])
    data['1h_stochastic_rsi'] = IndicatorCalculator.calculate_stochastic_rsi(data['1h'])
    data['1h_macd'] = IndicatorCalculator.calculate_macd(data['1h'])

    strategy_runner = StrategyRunner.new('trend_following_stochastic_macd', data)
    trades = strategy_runner.execute

    backtest = Backtest.create!(
      strategy: 'trend_following_stochastic_macd',
      parameters: params[:backtest].permit(:trading_pair_id, :from, :to),
      start_time: Time.at(from),
      end_time: Time.at(to),
      profit_loss: trades.sum { |trade| trade[:profit_loss] }
    )

    trades.each do |trade|
      BacktestTrade.create!(
        backtest: backtest,
        side: trade[:side],
        entry_price: trade[:entry],
        exit_price: trade[:exit],
        trading_pair_id: trading_pair_id,
        entry_date: Time.at(trade[:entry_time]),
        exit_date: Time.at(trade[:exit_time]),
        quantity: trade[:quantity],
        profit_loss: trade[:profit_loss],
        fees: trade[:fees],
        trade_duration: trade[:trade_duration]
      )
    end

    redirect_to backtest_path(backtest)
  end

  def show
    @backtest = Backtest.find(params[:id])
  end

  def index
    @backtests = Backtest.all
  end
end

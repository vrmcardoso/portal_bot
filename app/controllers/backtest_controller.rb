class BacktestsController < ApplicationController
  def create
    symbol = params[:symbol]
    from = params[:from].to_i
    to = params[:to].to_i

    historical_data_service = HistoricalDataService.new
    data = historical_data_service.fetch_multiple_intervals(symbol, ['1h', '1d', '1w'], from, to)

    # Calculate indicators
    data['1d'] = IndicatorCalculator.calculate_stochastic_rsi(data['1d'])
    data['1d'] = IndicatorCalculator.calculate_macd(data['1d'])
    data['1w'] = IndicatorCalculator.calculate_stochastic_rsi(data['1w'])
    data['1w'] = IndicatorCalculator.calculate_macd(data['1w'])
    data['1h'] = IndicatorCalculator.calculate_stochastic_rsi(data['1h'])
    data['1h'] = IndicatorCalculator.calculate_macd(data['1h'])

    strategy_runner = StrategyRunner.new('trend_following_stochastic_macd', data)
    trades = strategy_runner.execute

    backtest = Backtest.create!(
      strategy_name: 'trend_following_stochastic_macd',
      parameters: params.permit(:symbol, :from, :to),
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
        trading_pair_id: trade[:trading_pair_id],
        entry_date: Time.at(trade[:entry_time]),
        exit_date: Time.at(trade[:exit_time]),
        quantity: trade[:quantity],
        profit_loss: trade[:profit_loss],
        fees: trade[:fees],
        trade_duration: trade[:trade_duration]
      )
    end

    render json: { backtest: backtest, trades: backtest.backtest_trades }
  end

  def index
    @backtests = Backtest.all
    render json: @backtests, include: :backtest_trades
  end
end

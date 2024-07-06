class AddBacktestIdToBacktestTrades < ActiveRecord::Migration[7.1]
  def change
    add_reference :backtest_trades, :backtest, null: false, foreign_key: true
  end
end

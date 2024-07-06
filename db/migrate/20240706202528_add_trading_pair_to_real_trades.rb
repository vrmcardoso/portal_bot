class AddTradingPairToRealTrades < ActiveRecord::Migration[7.1]
  def change
    add_reference :real_trades, :trading_pair, null: false, foreign_key: true
  end
end

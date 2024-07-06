class AddTradingPairToPaperTrades < ActiveRecord::Migration[7.1]
  def change
    add_reference :paper_trades, :trading_pair, null: false, foreign_key: true
  end
end

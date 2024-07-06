class CreateBacktestTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :backtest_trades do |t|
      t.string :side
      t.decimal :entry_price
      t.decimal :exit_price
      t.references :trading_pair, null: false, foreign_key: true
      t.datetime :entry_date
      t.datetime :exit_date
      t.decimal :quantity
      t.decimal :profit_loss
      t.decimal :fees
      t.integer :trade_duration

      t.timestamps
    end
  end
end

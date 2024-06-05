class AddFieldsToTrades < ActiveRecord::Migration[7.1]
  def change
    add_column :trades, :trade_type, :string
    add_column :trades, :backtest, :boolean, default: false
    change_column :trades, :trading_pair, :string, null: false
  end
end

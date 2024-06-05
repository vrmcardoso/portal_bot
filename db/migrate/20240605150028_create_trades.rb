class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.string :side
      t.decimal :entry_price
      t.decimal :exit_price
      t.string :trading_pair
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

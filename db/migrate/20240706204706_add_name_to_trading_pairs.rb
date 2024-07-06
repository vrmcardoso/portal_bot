class AddNameToTradingPairs < ActiveRecord::Migration[7.1]
  def change
    add_column :trading_pairs, :name, :string
  end
end

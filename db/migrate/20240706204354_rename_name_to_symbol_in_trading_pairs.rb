class RenameNameToSymbolInTradingPairs < ActiveRecord::Migration[7.1]
  def change
    rename_column :trading_pairs, :name, :symbol
  end
end

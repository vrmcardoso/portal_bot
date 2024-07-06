class CreateTradingPairs < ActiveRecord::Migration[7.1]
  def change
    create_table :trading_pairs do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

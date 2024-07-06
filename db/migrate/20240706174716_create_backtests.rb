class CreateBacktests < ActiveRecord::Migration[7.1]
  def change
    create_table :backtests do |t|
      t.string :strategy
      t.json :parameters
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :profit_loss

      t.timestamps
    end
  end
end

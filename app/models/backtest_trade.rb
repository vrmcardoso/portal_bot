class BacktestTrade < ApplicationRecord
  belongs_to :trading_pair
  belongs_to :backtest

  validates :side, presence: true, inclusion: { in: %w[Long Short] }
  validates :entry_price, :exit_price, :quantity, numericality: { greater_than or_equal_to: 0 }
  validates :profit_loss, :fees, numericality: true
  validates :trading_pair, presence: true, inclusion: { in: TRADING_PAIRS }
  validates :entry_date, :exit_date, presence: true

end

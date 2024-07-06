class Backtest < ApplicationRecord
  has_many :backtest_trades, dependent: :destroy

  validates :strategy, presence: true
  validates :start_time, :end_time, presence: true
end

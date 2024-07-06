class TradingPair < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :real_trades
  has_many :paper_trades
  has_many :backtest_trades
end

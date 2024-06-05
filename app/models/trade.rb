class Trade < ApplicationRecord
    TRADING_PAIRS = %w[BTCUSDT ETHUSDT].freeze

    validates :side, presence: true, inclusion: { in: %w[Long Short] }
    validates :entry_price, :exit_price, :quantity, numericality: { greater_than_or_equal_to: 0 }
    validates :profit_loss, :fess, numericality: true
    validates :trading_pair, presence: true, inclusion: { in: TRADING_PAIRS }
    validates :entry_date, :exit_date, presence: true
    validates :trade_type, presence: true, inclusion: { in: %w[real paper] }
    validates :backtest, inclusion: { in: [true, false] }
  
    def self.add_trading_pair(pair)
      TRADING_PAIRS << pair unless TRADING_PAIRS.include?(pair)
    end
  end
  

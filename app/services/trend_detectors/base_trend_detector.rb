class BaseTrendDetector
  def initialize(data)
    @data = data
  end

  def detect_trend_at(timestamp)
    raise NotImplementedError, "Subclasses must implement the `detect_trend_at` method"
  end
end

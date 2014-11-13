class GoogleFinanceParser

  BASE_URL = "https://www.google.com/finance?fstype=ii&q="

  def initialize(ticker)
    @ticker = ticker
  end

  def fetch
    query_url = BASE_URL + @ticker
  end
end

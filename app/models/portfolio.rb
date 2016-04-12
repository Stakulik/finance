# == Schema Information
#
# Table name: portfolios
#
#  id          :integer          not null, primary key
#  name        :string(30)       not null
#  description :string(200)
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Portfolio < ActiveRecord::Base
  has_many :stocks, :dependent => :destroy
  belongs_to :user

  validates :name, presence: true, length: { in: 1..30 }
  validates :user_id, presence: true
  validates :description, length: { in: 0..200 }


  @@stocks_history = {}

  def get_data_about_stocks(count_years = 2)
    prices_by_days = get_prices_by_days(get_stocks, count_years)

    convert_for_metrics(prices_by_days)
  end

  def get_stocks
    demanded_stocks = stocks.demanded
    return [] if demanded_stocks.empty?

    stocks_names = demanded_stocks.map(&:name)

    yahoo_today_data = try_use_yahoo(stocks_names, nil)
    
    yahoo_today_data ? filter_today_data(yahoo_today_data, demanded_stocks) : []
  end

  def get_prices_by_days(stocks_collection, count_years)
    prices_by_days = {}
    
    stocks_collection.each do |stock_and_yahoo_data|
      stock, yahoo_today_data = stock_and_yahoo_data

      data_by_days = get_finance_quotes(stock, count_years, yahoo_today_data)
      next unless data_by_days

      calculate_prices_for_stock(data_by_days, prices_by_days, stock.amount)
    end

    prices_by_days
  end

  def convert_for_metrics(prices_by_days)
    date_value = []

    prices_by_days.each do |k, v|
      date_value << {date: k, value: v}
    end
    
    date_value
  end

  def try_use_yahoo(stocks, count_years)
    @yahoo_client = YahooFinance::Client.new
    yahoo_data = nil

    begin
      yahoo_data = if count_years
        stock = stocks.first
        date_today = Date.today

        @yahoo_client.historical_quotes( stock.name, 
                                         { start_date: date_today - count_years.years,
                                           end_date: date_today } )
      else
        @yahoo_client.quotes(stocks, [:low, :high, :last_trade_date])
      end
    rescue StandardError => e
      logger.error e.message
      logger.error e.backtrace.inspect
    end

    yahoo_data
  end

  def filter_today_data(yahoo_today_data, demanded_stocks)
    stocks_collection = []

    yahoo_today_data.each.with_index do |stock_yahoo_data, i|
      next if stock_yahoo_data.last_trade_date == "N/A"

      stocks_collection.push([demanded_stocks[i], stock_yahoo_data])
    end

    stocks_collection
  end

  def get_finance_quotes(stock, count_years, yahoo_today_data)
    data_by_days = get_history_data(stock.name) || get_yahoo_data(stock, count_years)
    return nil unless data_by_days

    add_today_data(data_by_days, stock.name, yahoo_today_data)
  end

  def calculate_prices_for_stock(data_by_days, prices_by_days, stock_amount)
    data_by_days.reverse.each do |day_data|
      date, average_price = retrieve_data(day_data)

      prices_by_days[date] = 0 unless prices_by_days[date]
      prices_by_days[date] += average_price * stock_amount
    end

    prices_by_days
  end

  # @@stocks_history looks like { :AAPL => [ "07.04.2016", yahoo_data ] }
  # and holds yahoo's today data about stock if today earlier was query about this stock
  def get_history_data(stock_name)
    history_data = @@stocks_history[stock_name.to_sym].deep_dup
    return nil unless history_data

    if history_data[0] == Date.today.strftime('%d.%m.%Y')
      history_data[1] 
    else
      nil
    end
  end

  def get_yahoo_data(stock, count_years)
    yahoo_data = try_use_yahoo([stock], count_years)

    update_history_data(stock.name, yahoo_data) if yahoo_data

    yahoo_data
  end

  def add_today_data(data_by_days, stock_name, yahoo_today_data)
    return data_by_days unless yahoo_today_data.last_trade_date == Date.today.strftime('%-m/%-d/%Y')

    yahoo_today_data.trade_date = Date.today.strftime('%Y-%m-%d')
    data_by_days.unshift(yahoo_today_data)
  end

  def retrieve_data(day_data)
    date = day_data[:trade_date]

    average_price = (day_data.low.to_f + day_data.high.to_f) / 2 
    average_price = average_price.round(2)

    [date, average_price]
  end

  def update_history_data(stock_name, yahoo_data)
    @@stocks_history[stock_name.to_sym] = [Date.today.strftime('%d.%m.%Y'), yahoo_data.deep_dup]
  end

end
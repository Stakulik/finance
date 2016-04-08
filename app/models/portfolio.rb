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
  has_many :stocks
  belongs_to :user

  validates :name, presence: true, length: { in: 1..30 }
  validates :user_id, presence: true
  validates :description, length: { in: 0..200 }

  accepts_nested_attributes_for :stocks, allow_destroy: true


  @@stocks_history = {}

  def price_for_years(count_years = 2)
    @yahoo_client = YahooFinance::Client.new
    prices_by_days = {}

    stocks.each do |stock|
      next if stock.amount == 0

      data_by_days = get_finance_quotes(stock, count_years)
      next unless data_by_days

      prices_by_days = calculate_prices_for_stock(data_by_days, prices_by_days, stock.amount)
    end

    convert_for_metrics(prices_by_days)
  end

  def get_finance_quotes(stock, count_years)
    data_by_days = get_history_data(stock.name)
    data_by_days ||= get_yahoo_data(stock, count_years)

    return nil unless data_by_days

    add_today_data(data_by_days, stock)
  end

  # @@stocks_history looks like { :AAPL => [ "07.04.2016", yahoo_data ] }
  # and holds yahoo's today data about stock if today earlier was query about this stock
  def get_history_data(stock_name)
    history_data = @@stocks_history[stock_name.to_sym].deep_dup

    return nil unless history_data

    if history_data[0] == Time.now.strftime('%d.%m.%Y')
      history_data[1] 
    else
      nil
    end
  end

  def get_yahoo_data(stock, count_years)
    yahoo_data = try_use_yahoo(stock, count_years)

    update_history_data(stock.name, yahoo_data) if yahoo_data

    yahoo_data
  end

  def try_use_yahoo(stock, count_years)
    time_now = Time.now
    yahoo_data = nil

    begin
      yahoo_data = if count_years
        @yahoo_client.historical_quotes( stock.name, 
                                         { start_date: time_now - count_years.years,
                                           end_date: time_now } )
      else
        @yahoo_client.quotes([stock.name], [:low, :high, :trade_date])
      end

      sleep(0.3)
    rescue Exception => e
      logger.error "Problem around getting data about #{stock.name} stock"
      logger.error e.message
      logger.error e.backtrace.inspect
    end

    yahoo_data
  end

  def update_history_data(stock_name, yahoo_data)
    @@stocks_history[stock_name.to_sym] = [Time.now.strftime('%d.%m.%Y'), yahoo_data.deep_dup]
  end

  def add_today_data(data_by_days, stock)
    yahoo_today_data = try_use_yahoo(stock, nil).try(:first)

    if yahoo_today_data
      yahoo_today_data[:trade_date] = Time.now.strftime('%Y-%m-%d')

      data_by_days.unshift(yahoo_today_data)
    end

    data_by_days
  end

  def calculate_prices_for_stock(data_by_days, prices_by_days, stock_amount)
    data_by_days.reverse.each do |day_data|
      date, average_price = retrieve_data(day_data)

      prices_by_days[date] = 0 unless prices_by_days[date]
      prices_by_days[date] += average_price * stock_amount
    end

    prices_by_days
  end

  def retrieve_data(day_data)
    date = day_data[:trade_date]

    average_price = (day_data.low.to_f + day_data.high.to_f) / 2 
    average_price = average_price.round(2)

    [date, average_price]
  end

  def convert_for_metrics(prices_by_days)
    date_value = []

    prices_by_days.each do |k, v|
      date_value << {date: k, value: v}
    end
    
    date_value
  end

end
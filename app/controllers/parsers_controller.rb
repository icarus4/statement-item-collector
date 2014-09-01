class ParsersController < ApplicationController

  before_action :get_parse_params, except: [:ifrs, :gaap, :index]

  def index
    @stocks = Stock.all
  end

  def parse
    ticker  = params[:ticker]
    statement_subtype = params[:s_subtype]
    raise 's_subtype should be c or i' if statement_subtype != 'c' && statement_subtype != 'i'
    parse_stocks([]<<ticker, @start_year, @start_quarter, @end_year, @end_quarter, statement_subtype)
  end

  def parse_bank_stocks
    stocks = TwseWebStatement.bank_stocks
    stocks.delete_if {|x| x < params[:start_ticker].to_i} if params[:start_ticker].present?
    parse_stocks(stocks, @start_year, @start_quarter, @end_year, @end_quarter, @s_subtype)
    render :index
  end

  def parse_insurance_stocks
    stocks = TwseWebStatement.insurance_stocks
    stocks.delete_if {|x| x < params[:start_ticker].to_i} if params[:start_ticker].present?
    parse_stocks(stocks, @start_year, @start_quarter, @end_year, @end_quarter, @s_subtype)
    render :index
  end

  def parse_broker_stocks
    stocks = TwseWebStatement.broker_stocks
    stocks.delete_if {|x| x < params[:start_ticker].to_i} if params[:start_ticker].present?
    parse_stocks(stocks, @start_year, @start_quarter, @end_year, @end_quarter, @s_subtype)
    render :index
  end

  def parse_financial_stocks
    stocks = TwseWebStatement.financial_stocks
    stocks.delete_if {|x| x < params[:start_ticker].to_i} if params[:start_ticker].present?
    parse_stocks(stocks, @start_year, @start_quarter, @end_year, @end_quarter, @s_subtype)
    render :index
  end

  def ifrs
    case params[:table_name]
      when 'bs' then table_name = '資產負債表'
      when 'is' then table_name = '綜合損益表'
      when 'cf' then table_name = '現金流量表'
      else table_name = 'root'
    end

    @category = params[:category]
    @sub_category = params[:sub_category]

    @s_type = 'ifrs'
    @item = Item.where(name: table_name, s_type: 'ifrs').first
  end

  def gaap
    case params[:table_name]
      when 'bs' then table_name = '資產負債表'
      when 'is' then table_name = '損益表'
      when 'cf' then table_name = '現金流量表'
      else table_name = 'root'
    end

    @category = params[:category]
    @sub_category = params[:sub_category]

    @s_type = 'gaap'
    @item = Item.where(name: table_name, s_type: 'gaap').first
    render :ifrs
  end


  private

  def get_parse_params
    @start_year = @start_quarter = @end_year = @end_quarter = @s_subtype = @start_ticker = nil
    @start_year = params[:start_year].to_i if params[:start_year]
    @start_quarter = params[:start_quarter].to_i if params[:start_quarter]
    @end_year = params[:end_year].to_i if params[:end_year]
    @end_quarter = params[:end_quarter].to_i if params[:end_quarter]
    @s_subtype = params[:s_subtype]
    @start_ticker = params[:start_ticker] if params[:start_ticker].present?
  end

  def parse_stocks(stock_array, start_year=nil, start_quarter=nil, end_year=nil, end_quarter=nil, s_subtype=nil)
    start_year = start_year.presence || 2013
    start_quarter = start_quarter.presence || 1
    end_year = end_year.presence || 2014
    end_quarter = end_quarter.presence || 1
    s_subtype = s_subtype.presence || 'c'

    parse_counter = 0
    stock_array.each do |ticker|
      (start_year..end_year).to_a.each do |year|

        _start_quarter = year == start_year ? start_quarter : 1
        _end_quarter = year == end_year ? end_quarter : 4

        (_start_quarter.._end_quarter).to_a.each do |quarter|
          # sleep for a while successively parse 20 statements
          if parse_counter > 20
            sleep 30
            parse_counter = 0
          end
          @s = TwseWebStatement.new(ticker.to_s, year, quarter, s_subtype)
          @s.parse
          flash[:warning] = @s.result
          parse_counter += 1
        end
      end
    end
  end

  def debug_log(str)
    Rails.logger.debug str
  end

end

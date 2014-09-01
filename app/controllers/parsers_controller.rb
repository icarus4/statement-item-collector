class ParsersController < ApplicationController

  def index
  end

  def parse
    ticker  = params[:ticker]
    year    = params[:year].to_i
    quarter = params[:quarter].to_i

    @s = TwseWebStatement.new(ticker, year, quarter)
    if @s.parse.nil?
      debug_log "failed to parse #{ticker} #{year}-Q#{quarter}"
      flash[:warning] = '抓取失敗'
    end
  end

  def parse_bank_stocks
    parse_stocks(TwseWebStatement.bank_stocks)
    render :index
  end

  def parse_assurance_stocks
    parse_stocks(TwseWebStatement.assurance_stocks)
    render :index
  end

  def parse_broker_stocks
    parse_stocks(TwseWebStatement.broker_stocks)
    render :index
  end

  def parse_financial_stocks
    parse_stocks(TwseWebStatement.financial_stocks)
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

  def parse_stocks(stock_array)
    start_year = 2013
    start_quarter = 1
    end_year = 2014
    end_quarter = 1

    start_year = params[:start_year].to_i if params[:start_year]
    start_quarter = params[:start_quarter].to_i if params[:start_quarter]
    end_year = params[:end_year].to_i if params[:end_year]
    end_quarter = params[:end_quarter].to_i if params[:end_quarter]

    stock_array.each do |ticker|
      (start_year..end_year).to_a.each do |year|

        _start_quarter = year == start_year ? start_quarter : 1
        _end_quarter = year == end_year ? end_quarter : 4

        (_start_quarter.._end_quarter).to_a.each do |quarter|
          s = TwseWebStatement.new(ticker.to_s, year, quarter)
          s.parse
        end

      end
      sleep 60
    end
  end

  def debug_log(str)
    Rails.logger.debug str
  end

end

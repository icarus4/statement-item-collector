require 'open-uri'

class GoogleFinanceParser

  attr_reader :ticker, :doc,
              :annual_is_tb, :annual_bs_tb, :annual_cf_tb,
              :is_unit, :bs_unit, :cf_unit,
              :data, :is_data, :bs_data, :cf_data

  BASE_URL = "https://www.google.com/finance?fstype=ii&q="

  def initialize(ticker)
    @ticker = ticker.upcase
  end

  def parse
    query_url = BASE_URL + @ticker
    @doc = Nokogiri::HTML(open(query_url))
    @annual_is_tb, @annual_bs_tb, @annual_cf_tb = get_data_tables(@doc)
    @is_unit, @bs_unit, @cf_unit = get_base_unit(@annual_is_tb, @annual_bs_tb, @annual_cf_tb)
    @end_date_array = parse_fiscal_period_end_date(@annual_is_tb)
    @is_data = parse_table(@annual_is_tb)
    @bs_data = parse_table(@annual_bs_tb)
    @cf_data = parse_table(@annual_cf_tb)

    # merge @is_data, @bs_data, @cf_data to @data
    @data = @is_data.merge(@bs_data) {|k,a,b| a.merge b }
    @data.merge!(@cf_data) {|k,a,b| a.merge b}

    # return @annual_is_tb, @annual_bs_tb, @annual_cf_tb
    return self
  end

  private

    def get_data_tables(doc)
      annual_is_tbs = doc.css('div#incannualdiv table')
      annual_bs_tbs = doc.css('div#balannualdiv table')
      annual_cf_tbs = doc.css('div#casannualdiv table')

      if annual_is_tbs.size != 1 || annual_bs_tbs.size != 1 || annual_cf_tbs.size != 1
        raise 'html content error'
      end

      return annual_is_tbs.first, annual_bs_tbs.first, annual_cf_tbs.first
    end

    def get_base_unit(is_tb, bs_tb, cf_tb)
      is_unit_str = is_tb.css('thead tr th').first.text.strip
      bs_unit_str = bs_tb.css('thead tr th').first.text.strip
      cf_unit_str = cf_tb.css('thead tr th').first.text.strip

      # xx_unit_str may be "In Millions of USD (except for per share items)"
      is_unit = bs_unit = cf_unit = nil

      is_unit = 1_000_000 if is_unit_str.include? "In Millions of USD"
      bs_unit = 1_000_000 if bs_unit_str.include? "In Millions of USD"
      cf_unit = 1_000_000 if cf_unit_str.include? "In Millions of USD"
      is_unit = 1_000 if is_unit_str.include? "In Thousands of USD"
      bs_unit = 1_000 if bs_unit_str.include? "In Thousands of USD"
      cf_unit = 1_000 if cf_unit_str.include? "In Thousands of USD"

      raise 'cannot get correct unit' if is_unit.nil? || bs_unit.nil? || cf_unit.nil?

      return is_unit, bs_unit, cf_unit
    end

    def parse_table(tb)
      return nil unless tb.is_a? Nokogiri::XML::Element

      # get trs
      trs = tb.css('tbody tr')
      return nil if trs.size == 0

      # ret will be something like: { '20131231' => { "Revenue" => 1234567, "Net Income" => 123123 } , '20121231' => { ... } }
      ret = {}
      @end_date_array.each {|date| ret[date] = {}}
      # a tr is something like "Revenue 7,872.00  5,089.00  3,711.00  1,974.00"
      trs.each do |tr|
        item_name = ''
        # a td is an item name or a value
        tr.css('td').each_with_index do |td, td_index|
          if td_index == 0
            item_name = td.text.strip # item_name ex: "Revenue"
          elsif td_index >= 1
            # '-' means no value
            if td.text.strip == '-'
              ret[@end_date_array[td_index-1]][item_name] = nil
            else
              value_str = td.text.strip.tr(',','') # value_str ex: "7872.00"
              if item_name.downcase.include?('eps') || item_name.downcase.include?('per share')
                # don't multiply with xx_unit for per share items (ex: "Diluted Normalized EPS", "Dividends per Share - Common Stock Primary Issue")
                # ret["20131231"]["Revenue"] = xxxxx => ret = { '20131231' => { 'Revenue' => xxxxx } }
                ret[@end_date_array[td_index-1]][item_name] = value_str.to_f
              else
                # multiply with xx_unit if not per share items
                ret[@end_date_array[td_index-1]][item_name] = (value_str.to_f * @is_unit).to_i
              end
            end
          end
        end
      end

      return ret
    end

    def parse_fiscal_period_end_date(tb)
      end_date_str_array = []

      tb.css('thead tr th').each do |th|
        text = th.text.strip # text may be something like: "12 months ending 2013-12-31"

        next if text.include? 'USD' # skip the first th, which is something like "In Millions of USD (except for per share items)"

        if text.include? 'ending'
          date_str = text.split.last.tr('-','') # "12 months ending 2013-12-31" => "20131231"

          # simple check to validate date string
          raise 'Error fiscal period end date format' if date_str.length != 8 || date_str.to_i.to_s != date_str
          end_date_str_array << date_str
        else
          raise 'Error when parsing fiscal period end date'
        end

      end

      return end_date_str_array
    end
end

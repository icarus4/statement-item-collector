class ParsersController < ApplicationController

  def index
  end

  def search
    ticker  = params[:ticker]
    year    = params[:year].to_i
    quarter = params[:quarter].to_i

    @s = TwseWebStatement.new(ticker, year, quarter)
    @s.parse
  end

end


class TwseWebStatement
  attr_reader :ticker, :year, :quarter,
    :market, :statement_type, :category,
    :result, :data_source,
    :doc, :html,
    :bs_content, :is_content, :cf_content,
    :bs_table_nodeset, :is_table_nodeset, :cf_table_nodeset
  STATEMENT_FOLDER = Rails.root.join('doc')

  def initialize(ticker, year, quarter)
    raise 'invalid year' if year > Time.now.year
    raise 'invalid quarter' if quarter > 4 or quarter < 1

    @ticker = ticker
    @year = year
    @quarter = quarter
    @market = 'tw'
    @statement_type = year >= 2013 ? 'ifrs' : 'gaap'
    @category = get_category(ticker)
  end

  def parse
    html_file = get_html_file(@ticker, @year, @quarter)
    @doc = Nokogiri::HTML(html_file, nil, 'UTF-8')
    get_tables
    parse_tables
  end


  private

  def parse_tables
    @bs_table_nodeset.css('tr').each do |tr|
      name = _get_tr_item_name(tr)
      level = _get_tr_item_level(tr)
    end
  end

  def _get_tr_item_name(tr)
    raise 'invalid input (should be Nokogiri nodeset)' unless tr.is_a?(Nokogiri::XML::Element)
    tr.children[0].content.strip.gsub(/[　 ]/, '') # 移除前後全/半型空白
  end

  def _get_tr_item_level(tr)
    raise 'invalid input (should be Nokogiri nodeset)' unless tr.is_a?(Nokogiri::XML::Element)

  end

  def get_tables
    @result = @doc

    # check whether data is existed or not
    if @doc.css('html > body > center > h4 > font').first.try(:content) == '查無資料'
      debug_log "查無資料，full html content:\n#{@doc}"
      return @result = nil
    end

    @html = @doc.at_css('html html')

    # get 資產負債表 / 損益表 / 現金流量表
    @bs_table_nodeset = @doc.css('html body center table')[1]
    @is_table_nodeset = @doc.css('html body center table')[2]
    @cf_table_nodeset = @doc.css('html body center table')[3]

    # todo: check content is valid or not

    @bs_content = @bs_table_nodeset.content
    @is_content = @is_table_nodeset.content
    @cf_content = @cf_table_nodeset.content

  end

  def get_html_file(ticker, year, quarter)

    file_path = html_file_storing_path(ticker, year, quarter)

    # get html file if already existed, otherwise get from TWSE
    if File.exist?(file_path)
      debug_log "opening #{ticker} (#{year}Q#{quarter}) local html file #{file_path}"
      html_file = open_local_html_file(file_path)
      @data_source = file_path
    else
      debug_log "getting #{ticker} (#{year}Q#{quarter}) html from TWSE"
      html_file = get_twse_html_statement_and_convert_to_utf8(ticker, year, quarter)
      @data_source = 'TWSE'
      File.open(file_path, 'w:UTF-8') {|f| f.write(html_file)}  # save to local
    end

    return html_file
  end

  def get_twse_html_statement_and_convert_to_utf8(ticker, year, quarter)

    url = 'http://mops.twse.com.tw/server-java/t164sb01'

    form_data = {
      step:       '1',
      DEBUG:      '',
      CO_ID:      ticker,
      SYEAR:      year,
      SSEASON:    quarter,
      REPORT_ID:  'C'
    }

    # get html
    html_file = RestClient.post(url, form_data)

    # big5 => utf8
    ic = Iconv.new("utf-8//TRANSLIT//IGNORE", "big5")
    return ic.iconv(html_file)
  end

  def html_file_storing_path(ticker, year, quarter)
    "#{STATEMENT_FOLDER}/#{ticker}-#{year}-Q#{quarter}.html"
  end

  def open_local_html_file(name)
    return File.open(Rails.root.join('doc', name), 'r:UTF-8')
    # ic = Iconv.new("utf-8//TRANSLIT//IGNORE", "big5")
    # return ic.iconv(html_file.read)
  end

  def get_category(ticker)
    if TWSE_FINANCE_STOCK_LIST.flatten.flatten.include?(ticker.to_i)
      return 'finance'
    else
      return 'common'
    end
  end

  def debug_log(str)
    Rails.logger.debug str
  end

  TWSE_FINANCE_STOCK_LIST = {
    bank: [
      2801, # 2801 彰銀
      2809, # 2809 京城銀
      2812, # 2812 台中銀
      2820, # 2820 華票
      2834, # 2834 臺企銀
      2836, # 2836 高雄銀
      2837, # 2837 萬泰銀
      2838, # 2838 聯邦銀
      2845, # 2845 遠東銀
      2847, # 2847 大眾銀
      2849, # 2849 安泰銀
      2880, # 2880 華南金
      2881, # 2881 富邦金
      2882, # 2882 國泰金
      2883, # 2883 開發金
      2884, # 2884 玉山金
      2885, # 2885 元大金
      2886, # 2886 兆豐金
      2887, # 2887 台新金
      2888, # 2888 新光金
      2889, # 2889 國票金
      2890, # 2890 永豐金
      2891, # 2891 中信金
      2892, # 2892 第一金
      5820, # 5820 日盛金
      5880  # 5880 合庫金
    ],

    assurance: [
      2816, # 2816 旺旺保
      2823, # 2823 中壽
      2832, # 2832 台產
      2833, # 2833 台壽保
      2850, # 2850 新產
      2851, # 2851 中再保
      2852, # 2852 第一保
      2867  # 2867 三商壽
    ],

    broker: [
      2855, # 2855 統一證
      2856, # 2856 元富證
      6005, # 6005 群益證
      6015, # 6015 宏遠證
      6016, # 6016 康和證
      6020, # 6020 大展證
      6021, # 6021 大慶證
      6022, # 6022 大眾證
      6023, # 6023 元大期
      6024  # 6024 群益期
    ]
  }

end


class Stack
  def initialize
    @stack = Array.new
  end

  def pop
    @stack.pop
  end

  def push(element)
    @stack.push(element)
    self
  end

  def size
    @stack.size
  end
end


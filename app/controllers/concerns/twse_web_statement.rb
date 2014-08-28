class TwseWebStatement
  attr_reader :ticker, :year, :quarter,
    :country, :statement_type, :category,
    :result, :data_source,
    :doc, :html,
    :bs_content, :is_content, :cf_content,
    :bs_table_nodeset, :is_table_nodeset, :cf_table_nodeset

  STATEMENT_FOLDER = Rails.root.join('doc')

  def initialize(ticker, year, quarter, statement_subtype='combined')
    raise 'invalid year' if year > Time.now.year
    raise 'invalid quarter' if quarter > 4 or quarter < 1

    @ticker = ticker
    @year = year
    @quarter = quarter
    @country = 'tw'
    @statement_type = year >= 2013 ? 'ifrs' : 'gaap'
    @statement_subtype = statement_subtype
    @category = get_category(ticker)
    # TODO: add sub_category
  end

  def parse

    # FIXME: should refind @result to better indicate whether parsing is success or not
    @result = true

    # html_file = nil
    # ['combined', 'individual'].each do |statement_subtype|

    #   html_file = get_html_file(@ticker, @year, @quarter, 'combined')

    #   begin
    #     raise if html_file.nil?
    #     raise if html_file.size < 20000
    #     @doc = Nokogiri::HTML(html_file, nil, 'UTF-8')
    #     get_tables
    #   rescue
    #     next if statement_subtype == 'combined'
    #     return nil if statement_subtype == 'individual'
    #   end
    # end

    # # unless get_tables
    # #   debug_log 'cannot get table'
    # #   @result = nil
    # #   return nil
    # # end


    # # save to local
    # file_path = html_file_storing_path(@ticker, @year, @quarter)
    # unless File.exist?(file_path)
    #   File.open(file_path, 'w:UTF-8') {|f| f.write(html_file)}
    # end

    # download and open web and xbrl statements
    return nil if open_statements.nil?

    # get or create stock and statement data
    @stock = Stock.find_or_create_by!(ticker: @ticker, country: @country, category: @category)
    @statement = @stock.statements.find_or_create_by!(year: @year, quarter: @quarter, s_type: @statement_type)

    # parse and create statement items
    parse_tables(@bs_table_nodeset)
    parse_tables(@is_table_nodeset)
    parse_tables(@cf_table_nodeset)
  end

  def self.financial_stocks
    TWSE_FINANCE_STOCK_LIST.map{|k,v| v}.flatten
  end

  def self.bank_stocks
    TWSE_FINANCE_STOCK_LIST[:bank]
  end

  def self.assurance_stocks
    TWSE_FINANCE_STOCK_LIST[:assurance]
  end

  def self.broker_stocks
    TWSE_FINANCE_STOCK_LIST[:broker]
  end


  private

  def open_statements

    html_file = nil
    xbrl_file = nil

    # get web
    retry_count = 0
    loop do
      return nil if retry_count > 3
      html_file = get_html_file(@ticker, @year, @quarter, @statement_subtype)
      break if html_file.present? && html_file.size > 20000
      sleep 3 # 降低被 server 擋 request 的機率
      retry_count += 1
    end

    # get xbrl
    retry_count = 0
    loop do
      return nil if retry_count > 3
      xbrl_file = get_xbrl_file
      break if xbrl_file.present? && xbrl_file.size > 20000
      sleep 3
      retry_count += 1
    end

    @html_file = html_file
    @xbrl_file = xbrl_file

  end

  def parse_tables(table_nodeset)
    tr_array = []
    table_nodeset.css('tr').each do |tr|
      tr_array << tr
    end
    _parse_each_table_item(tr_array, 0, 0, [], nil)
  end

  # last_item_array is an array contains previous items of each level
  # ex: last_item_array[1] is the previous item of the current level 1 item.
  def _parse_each_table_item(tr_array, curr_index, previous_level, last_item_array, item_stack)

    # init item_stack
    item_stack = Stack.new if item_stack.nil?

    # exit if reach last item
    return if curr_index == tr_array.size

    # get current item
    tr = tr_array[curr_index]

    # get current item name/level/value
    name = _get_tr_item_name(tr)
    level = _get_tr_item_level(tr, name)
    has_value, value = _get_tr_item_value(tr)

    # get last_item of current level
    last_item = last_item_array[level]

    if level == 0 # root

      item = Item.find_or_create_by!(name: 'root', level: level, has_value: has_value, s_type: @statement_type, previous_id: nil, next_id: nil)

    elsif level == previous_level + 1 # current is a child of previous item

      parent_item = item_stack.top

      # NO identical item exists
      unless item = parent_item.children.where(name: name, level: level, has_value: has_value, s_type: @statement_type).first
        previous_id = nil
        next_id = nil

        # if brother exists (brother is an item which is identical to the current item, EXCEPT has_value is opposite)
        if brother = parent_item.children.where(name: name, level: level, has_value: !has_value, s_type: @statement_type).first
          if has_value # if the current item has value, it should be positioned above its brother
            # position above its brother
            previous_id = brother.previous_id
            next_id = brother.id
            item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)

            previous_item_of_brother = brother.previous_item
            if previous_item_of_brother.present?
              # before insert current item:
              #   previous item of brother
              #   brother
              # after:
              #   previous item of brother
              #   current item              <== insert here
              #   brother
              previous_item_of_brother.next_id = item.id
              previous_item_of_brother.save!
            end

            brother.previous_id = item.id
            brother.save!
          else # if current item doesn't has value, it should be positioned under its brother
            # position under its brother
            previous_id = brother.id
            next_id = brother.next_id
            item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)

            next_item_of_brother = brother.next_item
            if next_item_of_brother.present?
              # before insert current item:
              #   brother
              #   next item of brother
              # after:
              #   brother
              #   current item          <== insert here
              #   next item of brother
              next_item_of_brother.previous_id = item.id
              next_item_of_brother.save!
            end

            brother.next_id = item.id
            brother.save!
          end

        # if brother doesn't exist but there is any sibling exists, it should be positioned above the first sibling
        elsif first_sibling = parent_item.children.where(previous_id: nil).first
          next_id = first_sibling.id
          item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)
          first_sibling.previous_id = item.id
          first_sibling.save!

        # there is NO any sibling exists
        else
          raise 'should not has any sibling' if parent_item.children.any? # should not has any sibling here
          item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)
        end # if brother = ...
      end # unless item = ...

    elsif level <= previous_level

      pop_count = previous_level - level + 1
      item_stack.pop(pop_count)
      parent_item = item_stack.top

      # if NO identical item exists
      unless item = parent_item.children.where(name: name, level: level, has_value: has_value, s_type: @statement_type).first
        # if brother exists
        if brother = parent_item.children.where(name: name, level: level, has_value: !has_value, s_type: @statement_type).first
          if has_value # if the current item has value, it should be positioned above its brother
            # position above its brother
            previous_id = brother.previous_id
            next_id = brother.id
            item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)

            previous_item_of_brother = brother.previous_item
            if previous_item_of_brother.present?
              # before insert current item:
              #   previous item of brother
              #   brother
              # after:
              #   previous item of brother
              #   current item              <== insert here
              #   brother
              previous_item_of_brother.next_id = item.id
              previous_item_of_brother.save!
            end

            brother.previous_id = item.id
            brother.save!
          else # if current item doesn't has value, it should be positioned under its brother
            # position under its brother
            previous_id = brother.id
            next_id = brother.next_id
            item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)

            next_item_of_brother = brother.next_item
            if next_item_of_brother.present?
              # before insert current item:
              #   brother
              #   next item of brother
              # after:
              #   brother
              #   current item          <== insert here
              #   next item of brother
              next_item_of_brother.previous_id = item.id
              next_item_of_brother.save!
            end

            brother.next_id = item.id
            brother.save!
          end # else

        # brother doesn't exist, so position under its previous item or under brother of its previous item
        else
          raise 'previous item should not be nil' if last_item.nil?

          # Set previous item to the brother of previous item if this previous item has value and has a brother
          # otherwise we will get things like as follows:
          #
          # 現金及約當現金 共 15 檔               <== 這兩檔互為 brother，應該擺在一起
          # 存放央行及拆借金融同業 共 15 檔
          # 現金及約當現金 共 11 檔               <== 這兩檔互為 brother，應該擺在一起
          #   庫存現金  共 5 檔
          #   零用及週轉金
          if last_item.has_value? && last_item.brother.present?
            last_item = last_item.brother
          end

          previous_id = last_item.id
          next_id = last_item.next_id
          item = parent_item.children.create!(name: name, level: level, has_value: has_value, s_type: @statement_type, previous_id: previous_id, next_id: next_id)

          next_item_of_last_item = last_item.next_item
          if next_item_of_last_item.present?
            # before insert current item:
            #   previous item
            #   next item of previous item
            # after:
            #   previous item
            #   current item          <== insert here
            #   next item of previous item
            next_item_of_last_item.previous_id = item.id
            next_item_of_last_item.save!
          end

          last_item.next_id = item.id
          last_item.save!
        end # if brother = ....
      end # unless item = ...

    else
      raise 'level error'
    end

    # Associate Statement and Item
    begin
      item.statements << @statement
    rescue
    end

    # Associate Stock and Item
    begin
      item.stocks << @stock
    rescue
    end

    last_item_array[level] = item
    item_stack.push(item)
    _parse_each_table_item(tr_array, curr_index+1, level, last_item_array, item_stack)

    return
  end

  def _get_tr_item_name(tr)
    raise 'invalid input (should be Nokogiri nodeset)' unless tr.is_a?(Nokogiri::XML::Element)
    name = tr.children[0].content.strip.gsub(/[　 ]/, '') # 移除前後全/半形空白
    raise 'Failed to get name' if name.blank?
    return name
  end

  def _get_tr_item_level(tr, name)
    # level 0: 會計項目
    # level 1: 資產負債表 / 損益表 / 現金流量表
    level = 1 + _get_tr_item_fullwidth_whitespace_count(tr)
    level = 0 if name == '會計項目'
    raise "Failed to get level. (level = #{level}, name = #{name})" if level == 1 and (name != '資產負債表' and name != '綜合損益表' and name != '現金流量表')
    return level
  end

  def _get_tr_item_value(tr)
    raise 'invalid input (should be Nokogiri nodeset)' unless tr.is_a?(Nokogiri::XML::Element)

    # Return false if a tr has only one td/th (ex: 資產負債表 / 綜合損益表 / 現金流量表)
    return false, nil if tr.children.size < 2

    # Return false if no value
    text = tr.children[1].text.strip
    return false, nil if text.blank?

    # Return false if not an integer
    value = text.gsub(/,/, '') # remove ',' for number with format: 123,456,789
    return false, nil unless value.is_number?

    return true, value
  end

  def _get_tr_item_fullwidth_whitespace_count(tr)
    raise 'invalid input (should be Nokogiri nodeset)' unless tr.is_a?(Nokogiri::XML::Element)
    whitespace_count = tr.children[0].content[/\A　*/].size # 計算全形空白數量
    raise 'whitespace_count should be equal to or larger than 0' if whitespace_count < 0
    return whitespace_count
  end

  def get_tables

    # check whether data is existed or not
    if @doc.css('html > body > center > h4 > font').first.try(:content) == '查無資料'
      debug_log "查無資料，full html content:\n#{@doc}"
      raise '查無資料'
    end

    @html = @doc.at_css('html html')

    # get 資產負債表 / 損益表 / 現金流量表
    @bs_table_nodeset = @doc.css('html body center table')[1]
    @is_table_nodeset = @doc.css('html body center table')[2]
    @cf_table_nodeset = @doc.css('html body center table')[3]
    raise 'Failed to get balance sheet tables' unless @bs_table_nodeset.is_a?(Nokogiri::XML::Element)
    raise 'Failed to get income statement tables' unless @is_table_nodeset.is_a?(Nokogiri::XML::Element)
    raise 'Failed to get cash flow tables' unless @cf_table_nodeset.is_a?(Nokogiri::XML::Element)

    # todo: check content is valid or not

    @bs_content = @bs_table_nodeset.try(:content)
    @is_content = @is_table_nodeset.try(:content)
    @cf_content = @cf_table_nodeset.try(:content)

    return true
  end

  def get_html_file(ticker, year, quarter, statement_subtype)

    file_path = html_file_storing_path(ticker, year, quarter)

    # get html file if already existed, otherwise get from TWSE
    if File.exist?(file_path)
      debug_log "opening #{ticker} (#{year}Q#{quarter}) local html file #{file_path}"
      html_file = open_local_file(file_path)
      @data_source = file_path
    else
      debug_log "getting #{ticker} (#{year}Q#{quarter}) html from TWSE"
      html_file = get_twse_ifrs_html_statement_and_convert_to_utf8(ticker, year, quarter, statement_subtype)
      @data_source = 'TWSE'
    end

    return html_file
  end

  def get_xbrl_file
    # TODO:...

    xbrl_file = open_local_file('xbrl/tifrs-fr1-m1-ci-cr-2330-2014Q1.xml')
  end

  def get_twse_ifrs_html_statement_and_convert_to_utf8(ticker, year, quarter, statement_subtype)

    report_id = statement_subtype == 'combined' ? 'C' : 'A'

    url = 'http://mops.twse.com.tw/server-java/t164sb01'

    form_data = {
      step:       '1',
      DEBUG:      '',
      CO_ID:      ticker,
      SYEAR:      year,
      SSEASON:    quarter,
      REPORT_ID:  report_id
    }

    # get html
    html_file = RestClient.post(
      url,
      form_data,
      user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36'
      # {
      #   Content-Length: '57',
      #   Content-Type: 'application/x-www-form-urlencoded',
      #   Cookie: '__utma=193825960.922472084.1403834714.1407900313.1407906729.10; __utmc=193825960; __utmz=193825960.1407906729.10.9.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)',
      #   Host: 'mops.twse.com.tw',
      #   Origin: 'http://mops.twse.com.tw',
      #   User-Agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36'
      #   Referer: 'http://mops.twse.com.tw/server-java/t164sb01',
      # }
    )

    # big5 => utf8
    ic = Iconv.new("utf-8//TRANSLIT//IGNORE", "big5")
    return ic.iconv(html_file)
  end

  def html_file_storing_path(ticker, year, quarter)
    "#{STATEMENT_FOLDER}/#{ticker}-#{year}-Q#{quarter}.html"
  end

  def xbrl_file_storing_path(ticker, year, quarter)
    "#{STATEMENT_FOLDER}/xbrl/#{ticker}-#{year}-Q#{quarter}.html"
  end

  def open_local_file(name)
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

  # @@TWSE_FINANCE_STOCK_LIST = TWSE_FINANCE_STOCK_LIST

end


class String
  def is_number?
    true if Float(self) rescue false
  end
end

class UsStocksController < ApplicationController
  def parse
    # dir_1 for Mac, dir_2 for Linux)
    statement_root_dir_1 = '/Users/icarus4/.sec_statement_parser/statements'
    statement_root_dir_2 = '/home/icarus4/.sec_statement_parser/statements'
    statement_root_dir = File.directory?(statement_root_dir_1) ? statement_root_dir_1 : statement_root_dir_2

    # Get file list array under statement_root_dir, but skip files with size greater than 20 MB
    max_file_size = 20 * 1024 * 1024 # 20 MB
    @statements_paths = Dir.glob("#{statement_root_dir}/**/*").reject { |f| File.directory?(f) || File.size(f) > max_file_size }

    @stocks_parse_count = 0
    @statements_parse_count = 0
    @items_parse_count = 0

    gfp = nil # GoogleFinanceParse instance
    @statements_paths.each do |path|
      # path is something like: '/Users/icarus4/.sec_statement_parser/statements/FB/10-K/fb-20131231.xml'
      ticker = path.split('/')[-3].upcase
      date_str = path.split(/[-.]/)[-2]
      end_date = Date.parse(date_str)
      year = date_str.slice(0,4).to_i

      # skip parsed stocks
      # here we consider a stock has 3 or over 3 statements is parsed
      next if Stock.where(ticker: ticker).first && Stock.where(ticker: ticker).first.statements.size >= 3

      next "invalid date_str #{date_str}" if date_str.size != 8 # this should not happen
      next 'invalid year' if year < 2009 || year > Time.now.year # this should not happen

      if gfp.nil? || gfp.ticker != ticker
        begin
          gfp = GoogleFinanceParser.new ticker
          gfp.parse
          @stocks_parse_count += 1
        rescue
          # TODO: save error in DB
          next # continue with next statement
        end
      end

      # continue with next statement if data is nil or there is NO such date string in gfp.data
      next if gfp.data.nil?
      next if ! gfp.data.has_key?(date_str)

      # create all StandardItem for the first time so as to get the correct order of standard item like Google Finance
      if StandardItem.all.size == 0
        gfp.data[date_str].each { |item_name, value| StandardItem.create(name: item_name) }
      end

      # open statement file
      file = File.open(path)
      doc = Nokogiri::XML(file)

      # Create record in DB
      @stock = Stock.find_or_create_by!(ticker: ticker, country: 'us')
      @statement = Statement.find_or_create_by!(stock_id: @stock.id, year: year, end_date: end_date, s_type: 'gaap')

      @statements_parse_count += 1

      gfp.data[date_str].each do |item_name,value|
        next if value.nil? # skip items with nil value

        nodes = doc.text_equals(value.to_s) # text_equals() only accepts string

        if nodes.size > 0
          is_exactly_matched = nodes.size == 1 ? true : false
          si = StandardItem.find_or_create_by!(name: item_name)

          nodes.each do |node|
            xbrl_name = node.name
            item = Item.find_or_create_by!(name: xbrl_name, s_type: 'gaap', namespace: node.namespace.prefix)
            ItemStandardItemPair.find_or_create_by(item_id: item.id, standard_item_id: si.id, is_exactly_matched: is_exactly_matched)
            @stock.items << item unless @stock.items.include?(item)
            @statement.items << item unless @statement.items.include?(item)

            @items_parse_count += 1
          end
        end
      end

      file.close
    end

    render plan_text: 'Done'
  end
end

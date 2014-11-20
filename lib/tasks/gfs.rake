namespace :gfs do

  desc "Parse google finance values"
  task :parse, [:starting_alphabet, :max_stock_parse_count] => :environment do |task, args|
    puts "Starting task at #{Time.now}"

    interrupted = false
    trap('INT') { interrupted = true }
    trap('TERM') { interrupted = true }

    # dir_1 for Mac, dir_2 for Linux)
    statement_root_dir_1 = '/Users/icarus4/.sec_statement_parser/statements'
    statement_root_dir_2 = '/home/icarus4/.sec_statement_parser/statements'
    statement_root_dir = File.directory?(statement_root_dir_1) ? statement_root_dir_1 : statement_root_dir_2

    starting_alphabet = args[:starting_alphabet].nil? ? nil : args[:starting_alphabet].upcase
    max_stock_parse_count = args[:max_stock_parse_count].to_i

    # Get file list array under statement_root_dir, but skip files with size greater than 20 MB
    max_file_size = 30 * 1024 * 1024 # 30 MB
    @statements_paths = Dir.glob("#{statement_root_dir}/**/*").sort.reject { |f| File.directory?(f) || File.size(f) > max_file_size }

    @stocks_parse_count = 0
    @statements_parse_count = 0
    @items_parse_count = 0

    gfp = nil # GoogleFinanceParse instance
    @statements_paths.each do |path|
      if interrupted == true
        puts "signal INT/TERM catched, exiting..."
        sleep 1
        break
      end

      # path is something like: '/Users/icarus4/.sec_statement_parser/statements/FB/10-K/fb-20131231.xml'
      begin
        ticker = path.split('/')[-3].upcase
        # if starting alphabet is assigned, only process tickers match alphabet
        if starting_alphabet
          next if ticker[0,starting_alphabet.length] != starting_alphabet
        end
        date_str = path.split(/[-.]/)[-2]
        end_date = Date.parse(date_str)
        year = date_str.slice(0,4).to_i
      rescue
        puts "Skip statement due to error path. ticker:#{ticker} date_str:#{date_str} end_date:#{end_date} year:#{year}"
        next
      end

      next "invalid date_str #{date_str}" if date_str.size != 8 # this should not happen
      next 'invalid year' if year < 2009 || year > Time.now.year # this should not happen

      if gfp.nil? || gfp.ticker != ticker
        begin
          if max_stock_parse_count > 0 # 0 is no limit
            exit if @stocks_parse_count >= max_stock_parse_count
          end
          gfp = GoogleFinanceParser.new ticker
          gfp.parse
          puts "\##{@stocks_parse_count+1}\/#{max_stock_parse_count}: Parsing #{ticker}..."
          @stocks_parse_count += 1
        rescue
          # TODO: save error in DB
          next # continue with next statement
        end
      end

      # continue with next statement if data is nil or there is NO such date string in gfp.data
      next if gfp.data.nil?
      next if ! gfp.data.has_key?(date_str)

      # Create record in DB
      @stock = Stock.find_or_create_by!(ticker: ticker, country: 'us')
      @statement = Statement.find_or_create_by!(stock_id: @stock.id, year: year, end_date: end_date, s_type: 'gaap')

      @statements_parse_count += 1

      # Save data from google finance
      gfp.data[date_str].each do |item_name,value|
        si = StandardItem.find_by(name: item_name)
        next if si.nil?
        vc = ValueComparison.find_or_create_by(statement_id: @statement.id, standard_item_id: si.id)
        vc.gfs_value = value
        vc.save
      end
    end # @statements_paths.each
  end # task parse:
end

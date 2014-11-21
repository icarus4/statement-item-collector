namespace :coverage do
  desc "TODO"
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

    @statements_paths.each do |path|
      # catch ctrl-c & SIGTERM
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

      begin
        xp = XbrlParser.new(path)
      rescue
        puts "Skip statementdue to number of dei:DocumentPeriodEndDate is not exactly 1. ticker:#{ticker} date_str:#{date_str} end_date:#{end_date} year:#{year}"
        next
      end

      # Find or create record
      @stock = Stock.find_or_create_by!(ticker: ticker, country: 'us')
      @statement = Statement.find_or_create_by!(stock_id: @stock.id, year: year, end_date: end_date, s_type: 'gaap')

      StandardItem.all.includes(:xbrl_names).each do |si|
        si.xbrl_names.each do |xbrl|
          vc = ValueComparison.find_or_create_by(standard_item_id: si.id, statement_id: @statement.id)

          # search xbrl for matching item
          value = xp.get_value_str_by_namespace_name('us-gaap', xbrl.xbrl_name)

          # we assume there is only one value existed, skip if we number of values is not one
          next if value == nil || value.size != 1
          # puts "#{ticker} #{si.name} #{value.first}"

          # assign and calculate comparison result
          vc.xbrl_value = value.first.to_f
          if vc.save
            vc.caclulate_value_comparison_result
          end
        end
      end
    end
  end
end

class UsStocksController < ApplicationController
  def index
    g = GoogleFinanceParser.new 'fb'
    g.parse

    @data = g.data
    # raise ''
  end

  def parse
    statement_root_dir = '/Users/icarus4/.sec_statement_parser/statements'

    # Get file list array under statement_root_dir
    @statements_paths = Dir.glob("#{statement_root_dir}/**/*").reject { |f| File.directory?(f) }

    gfp = nil
    @statements_paths.each do |path|
      # path is something like: '/Users/icarus4/.sec_statement_parser/statements/FB/10-K/fb-20131231.xml'
      ticker = path.split('/')[-3]
      date_str = path.split(/[-.]/)[-2]
      raise "invalid date_str #{date_str}" if date_str.size != 8

      # open statement file
      file = File.open(path)
      doc = Nokogiri::XML(file)

      if gfp.nil? || gfp.ticker != ticker
        gfp = GoogleFinanceParser.new ticker
        gfp.parse
      end

      gfp.data[date_str].each do |item_name,value|
        nodes = doc.text_equals(value.to_s) # text_equals() only accepts string
      end

      file.close
    end


  end
end

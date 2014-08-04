class ParsersController < ApplicationController

  def index
  end

  def search
    # f = get_twse_html_statement(params[:ticker])
    f = open_big5_html_file('2459-2014-Q1.html')

    s = TwseWebStatement.new(f)
    @s = s

  end


  private

  def open_big5_html_file(name)
    f = File.open(Rails.root.join('doc', name))
    ic = Iconv.new("utf-8//TRANSLIT//IGNORE", "big5")
    ic.iconv(f.read)
  end

  def get_twse_html_statement(ticker)

    url = 'http://mops.twse.com.tw/server-java/t164sb01'

    form_data = {
      step:       '1',
      DEBUG:      '',
      CO_ID:      ticker,
      SYEAR:      '2014',
      SSEASON:    '1',
      REPORT_ID:  'C'
    }

    html_doc = RestClient.post(url, form_data)
    ic = Iconv.new("utf-8//TRANSLIT//IGNORE", "big5")

    ic.iconv(html_doc)
  end

end


class TwseWebStatement
  attr_reader :doc, :html,
              :bs_content, :is_content, :cf_content,
              :bs_table_nodeset, :is_table_nodeset, :cf_table_nodeset

  def initialize(html)
    doc = Nokogiri::HTML(html)

    @doc = doc

    @html = doc.css('html').first.content

    @bs_table_nodeset = doc.css('html body table')[1]
    @is_table_nodeset = doc.css('html body table')[2]
    @cf_table_nodeset = doc.css('html body table')[3]

    @bs_content = @bs_table_nodeset.content
    @is_content = @is_table_nodeset.content
    @cf_content = @cf_table_nodeset.content

    return @doc
  end
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

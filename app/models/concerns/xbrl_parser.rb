class XbrlParser
  attr_reader :context_ref


  def initialize(path)
    f = File.open(path)
    @doc = Nokogiri::XML(f)
    f.close

    nodes = @doc.xpath("//dei:DocumentPeriodEndDate")
    raise "Find #{e.size} dei:DocumentPeriodEndDate, but should be exactly one dei:DocumentPeriodEndDate" if nodes.size != 1
    e = nodes.first
    @document_period_end_date = e.text
    @context_ref = e.attr('contextRef')
  end

  def get_value_str_by_namespace_name(namespace, name)
    nodes = @doc.xpath("//#{namespace}:#{name}[@contextRef='#{@context_ref}']")

    return nil if nodes.nil? || nodes.empty?
    return nodes.map(&:text)
  end
end

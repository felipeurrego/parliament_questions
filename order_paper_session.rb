require '/Users/andrew/Projects/OrderPapers/order_paper_parser.rb'

class OrderPaperSession
  attr_accessor :raw_html, :data
  attr_reader :key, :session_number, :title_text

  def initialize(raw_html)
    @raw_html = raw_html
    @data = {}
    @title_text = get_title_text
    @key = get_session_date
    @session_number = get_session_number
  end

  def create_data_hash
    data[key] = {session_number: session_number}
    questions = collect_questions_from_html
    questions.each do |question|
      parse_question(question)
    end
    data
  end

  def get_title_text
    raw_html.css("table.Item")[0].css('p > b')[0].text
  end

  def get_session_date
    title_text.match(/^\w+,\s([\w\s,]+)\s\(/)[1]
  end

  def get_session_number
    date_from_title = title_text.gsub(title_text.match(/^\w+,\s([\w\s,]+)\s\(/)[0], "")
    session_number = date_from_title.match(/\d+/)[0]
    session_number
  end

  def parse_question(question)
    parser = OrderPaperParser.new
    parser.convert_xml_to_text!(question)
    question_number = parser.slice_question_number!
    question_data = parser.convert_text_to_data

    data[key][question_number.to_sym] = question_data
  end

  private

    def collect_questions_from_html
      raw_html.css("td.ItemPara")
    end
end
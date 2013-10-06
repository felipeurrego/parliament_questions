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
    paper_date = parser.slice_paper_date!
    mp_name = parser.slice_mp_name!

    parser.text = parser.text.gsub(mp_name, "").strip

    mp_location = parser.text.match(/^\(([\w\—\s\'\.\-\é\è\â\Î\ê\î\É\È\Â\ô\Ô]+)\)/)[0]

    parser.text = parser.text.gsub(mp_location, "")

    mp_location = mp_location.gsub(/[\(\)]/, "")

    question_text = parser.text.gsub(/^[\s\—]+(\w+)/, '\1')

    data[key][question_number.to_sym] = {
      paper_date: paper_date,
      mp_name: mp_name,
      mp_location: mp_location,
      question_text: question_text
    }
  end

  private

    def collect_questions_from_html
      raw_html.css("td.ItemPara")
    end
end
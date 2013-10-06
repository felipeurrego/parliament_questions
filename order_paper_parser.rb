class OrderPaperParser

  attr_accessor :text

  def initialize
    @text = ""
  end

  def convert_xml_to_text!(xml)
    tidy_xml(xml)
    self.text = xml.text
  end

  def convert_text_to_data
    data = {
      paper_date: slice_paper_date!,
      mp_name: slice_mp_name!,
      mp_location: slice_mp_location!,
      question_text: text
    }
  end

  def slice_question_number!
    regex = /^Q-[\d]+\s—\s/
    result = text.slice!(regex)
    result.slice(/\d+/)
  end

  def slice_paper_date!
    regex = /^\w+\s[\d]{1,2},\s[\d]{4}[\s—]+/
    result = text.slice!(regex)
    result.slice(/\w+\s\d+,\s\w+/)
  end

  def slice_mp_name!
    regex = /^[\w\.\s\-\é\è\—\â\Î\ê\î\É\È\Â\ô\Ô]+[^\s\(]/
    result = text.slice!(regex)
    text.strip!
    result
  end

  def slice_mp_location!
    regex = /^\([\w\—\s\'\.\-\é\è\â\Î\ê\î\É\È\Â\ô\Ô]+\)[\s—]+/
    result = text.slice!(regex)
    result = result.slice(/[^\(\)]+/)
  end

  private

    def tidy_xml(xml)
      xml.css("b sup").remove
    end
end
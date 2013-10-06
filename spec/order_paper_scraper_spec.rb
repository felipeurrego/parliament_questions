require 'spec_helper'
require '/Users/andrew/Projects/OrderPapers/order_paper_scraper.rb'

describe OrderPaperScraper do

  let(:scraper) { OrderPaperScraper.new(url: "http://www.parl.gc.ca/housechamberbusiness/ChamberSittings.aspx?View=N&Language=E&Mode=1&Parl=41&Ses=1",
                                      base_url: 'http://www.parl.gc.ca') }

  describe "#get_questions_data" do
    it "should get data" do
      question_page = Nokogiri::HTML(open('/Users/andrew/Projects/OrderPapers/spec/assets/question_page.html'))
      question_link = scraper.stubs(:get_questions_link).returns("somepage.html")
      scraper.stubs(:get_questions_html).returns(question_page)
      scraper.get_questions_data(question_link).should be_an_instance_of(Hash)
    end
  end
end


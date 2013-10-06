require 'pry'
require 'pry-nav'
require 'nokogiri'
require 'open-uri'
require '/Users/andrew/Projects/OrderPapers/order_paper_parser.rb'

class OrderPaperScraper

  attr_reader :url, :base_url, :data

  def initialize(args)
    @base_url = args[:base_url]
    @url = args[:url]
    @data = {}
  end

  def scrape
    calendar_links = collect_calendar_links
    calendar_links.each do |link|
      data_hash = get_questions_data(link)
      data_hash.each do |k,v|
        @data[k.to_sym] = v
      end
    end
    @data
  end

  def get_questions_data(link)
    questions_link = get_questions_link(link)
    questions_html = get_questions_html(questions_link)
    parser = OrderPaperParser.new(questions_html)

    data_hash = parser.create_data_hash # parse this html into array format for @data
    data_hash
  end

  def get_questions_html(link)
    questions_html = open_html(link)
    questions_html
  end

  def get_questions_link(link)
    index_page = open_html(link)
    questions_link = ""
    index_page.css('a.DefaultTableOfContentsFile.Link').each do |toc_link|
      questions_link = (@base_url + toc_link['href'] + '&Col=1') if toc_link.text.include?("Questions")
    end
    questions_link
  end

  def open_html(link)
    Nokogiri::HTML(open(link))
  end

  def collect_calendar_links
    doc = open_html(url)

    calendar_links = []
    doc.css('.PublicationCalendarLink').each do |link|
      calendar_links << (@base_url + link["href"])
    end
    calendar_links
  end
end

# scraper = OrderPaperScraper.new(url: "http://www.parl.gc.ca/housechamberbusiness/ChamberSittings.aspx?View=N&Language=E&Mode=1&Parl=41&Ses=1",
#                                 base_url: 'http://www.parl.gc.ca')
# scraper.scrape
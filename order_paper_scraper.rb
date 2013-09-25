require 'pry'
require 'pry-nav'
require 'nokogiri'
require 'open-uri'

class OrderPaperScraper

  attr_reader :url, :doc, :base_url, :calendar_links, :data

  def initialize(args)
    @base_url = args[:base_url]
    @url = args[:url]
    @doc = Nokogiri::HTML(open(url))
    @data = {}
  end

  def scrape
    calendar_links = collect_calendar_links
    calendar_links.each do |link|
      questions_hash = get_questions_data(link)
      questions_hash.each do |k,v|
        @data[k.to_sym] = v
      end
    end
    @data
  end

  def get_questions_data(link)
    questions_link = get_questions_link(link)
    questions_html = get_questions_html(questions_link)
    question_hash = create_question_hash(questions_html) # parse this html into array format for @data
  end

  def get_questions_html(link)
    questions_html = Nokogiri::HTML(open(link))
    questions_html
  end

  def get_questions_link(link)
    index_page = Nokogiri::HTML(open(link))
    questions_link = ""
    index_page.css('a.DefaultTableOfContentsFile.Link').each do |link|
      questions_link = (@base_url + link['href'] + '&Col=1') if link.text.include?("Questions")
    end
    questions_link
  end

  def collect_calendar_links
    calendar_links = []
    @doc.css('.PublicationCalendarLink').each do |link|
      calendar_links << (@base_url + link["href"])
    end
    calendar_links
  end

  def create_question_hash(html)
    # {:"q-2141" => {:date => "2012-03-20", :content => "oprgkprkgrp"}}
    title_text = html.css("table.Item")[0].css('p > b')[0].text
    session_date = title_text.match(/^\w+,\s([\w\s,]+)\s\(/)[1]
    key = session_date.to_sym

    title_text = title_text.gsub(title_text.match(/^\w+,\s([\w\s,]+)\s\(/)[0], "")
    session_number = title_text.match(/\d+/)[0]

    @data[key] = {session_number: session_number}

    questions = html.css("td.ItemPara")
    questions.each_with_index do |question, index|
      puts "Index: #{index}\n"
      puts question.text

      question.css("b sup").remove
      text = question.text

      question_number = text.match(/^Q-[\d]+/)[0]

      text = text.gsub(question_number, "")
      text = text.gsub(/^[\s\—]+(\w+)/, '\1')

      question_number = question_number.match(/\d+/)[0]

      paper_date = text.match(/^(\w+\s[\d]{1,2},\s[\d]{4})/)[0]

      text = text.gsub(paper_date, "")
      text = text.gsub(/^[\s\—]+(\w+)/, '\1')

      mp_name = text.match(/^([\w\.\s\-\é\è\—\â\Î]+)[^\s\(]/)[0]

      text = text.gsub(mp_name, "").strip

      mp_location = text.match(/^\(([\w\—\s\'\.\-\é\è\â\Î]+)\)/)[0]

      text = text.gsub(mp_location, "")

      mp_location = mp_location.gsub(/[\(\)]/, "")

      question_text = text.gsub(/^[\s\—]+(\w+)/, '\1')

      @data[key][question_number.to_sym] = {
        paper_date: paper_date,
        mp_name: mp_name,
        mp_location: mp_location,
        question_text: question_text
      }
    end
    @data
  end
end

scraper = OrderPaperScraper.new(url: "http://www.parl.gc.ca/housechamberbusiness/ChamberSittings.aspx?View=N&Language=E&Mode=1&Parl=41&Ses=1",
                                base_url: 'http://www.parl.gc.ca')
scraper.scrape
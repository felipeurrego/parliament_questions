require 'spec_helper'
require '/Users/andrew/Projects/OrderPapers/order_paper_parser.rb'

describe OrderPaperParser do

  let(:parser) { parser = OrderPaperParser.new }

  describe "parsing" do
    it "should extract the question number" do
      parser.text = "Q-1035 — October 29, 2012  — Mr. Nicholls (Vaudreuil—Soulanges) — With regard to federal grants and contributions, what were the amounts paid out in the Vaudreuil-Soulanges riding between April 1, 2011, and October 25, 2012, broken down by (i) the identity and address of each recipient, (ii) the start date for the funding, (iii) the end date for the funding, (iv) the amount allocated, (v) the name of the program under which the funding was allocated?"
      parser.slice_question_number!.should == "1035"
      parser.text.should == "October 29, 2012  — Mr. Nicholls (Vaudreuil—Soulanges) — With regard to federal grants and contributions, what were the amounts paid out in the Vaudreuil-Soulanges riding between April 1, 2011, and October 25, 2012, broken down by (i) the identity and address of each recipient, (ii) the start date for the funding, (iii) the end date for the funding, (iv) the amount allocated, (v) the name of the program under which the funding was allocated?"
    end

    it "should extract the paper date" do
      parser.text = "October 29, 2012  — Mr. Nicholls (Vaudreuil—Soulanges) — With regard to federal grants and contributions, what were the amounts paid out in the Vaudreuil-Soulanges riding between April 1, 2011, and October 25, 2012, broken down by (i) the identity and address of each recipient, (ii) the start date for the funding, (iii) the end date for the funding, (iv) the amount allocated, (v) the name of the program under which the funding was allocated?"
      parser.slice_paper_date!.should == "October 29, 2012"
      parser.text.should == "Mr. Nicholls (Vaudreuil—Soulanges) — With regard to federal grants and contributions, what were the amounts paid out in the Vaudreuil-Soulanges riding between April 1, 2011, and October 25, 2012, broken down by (i) the identity and address of each recipient, (ii) the start date for the funding, (iii) the end date for the funding, (iv) the amount allocated, (v) the name of the program under which the funding was allocated?"
    end

    it "should extract the mp name" do
      parser.text = "Mr. Nicholls (Vaudreuil—Soulanges) — With regard to federal grants and contributions, what were the amounts paid out in the Vaudreuil-Soulanges riding between April 1, 2011, and October 25, 2012, broken down by (i) the identity and address of each recipient, (ii) the start date for the funding, (iii) the end date for the funding, (iv) the amount allocated, (v) the name of the program under which the funding was allocated?"
      parser.slice_mp_name!.should == "Mr. Nicholls"
      parser.text.should == "(Vaudreuil—Soulanges) — With regard to federal grants and contributions, what were the amounts paid out in the Vaudreuil-Soulanges riding between April 1, 2011, and October 25, 2012, broken down by (i) the identity and address of each recipient, (ii) the start date for the funding, (iii) the end date for the funding, (iv) the amount allocated, (v) the name of the program under which the funding was allocated?"
    end
  end
end
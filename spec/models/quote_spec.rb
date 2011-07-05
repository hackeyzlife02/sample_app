require 'spec_helper'

describe Quote do
  
  before(:each) do
    @client = Factory(:client)
    @attr = { :qtitle => "Incline" }
  end
  
  it "should create a new instance given valid attributes" do
      @client.quotes.create!(@attr)
  end

  describe "client associations" do

    before(:each) do
      @quote = @client.quotes.create(@attr)
    end

    it "should have a client attribute" do
      @quote.should respond_to(:client)
    end

    it "should have the right associated client" do
      @quote.client_id.should == @client.id
      @quote.client.should == @client
    end
  end
  
  describe "validations" do
    
    it "should have a client id" do
      Quote.new(@attr).should_not be_valid
    end
    
    it "should require a nonblank title" do
      @client.quotes.build(:qtitle => " ").should_not be_valid
    end
    
    it "should reject long titles" do
      @client.quotes.build(:qtitle => "a" * 46).should_not be_valid
    end
  end
  
end

# == Schema Information
#
# Table name: quotes
#
#  id         :integer         not null, primary key
#  qtitle     :string(255)
#  client_id  :integer
#  created_at :datetime
#  updated_at :datetime
#


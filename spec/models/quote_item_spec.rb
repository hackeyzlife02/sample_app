require 'spec_helper'

# == Schema Information
#
# Table name: quote_items
#
#  id         :integer         not null, primary key
#  item_num   :string(255)
#  desc       :string(255), maximum => 45
#  qty        :integer, maximum => 6
#  price      :decimal(8, 2), maximum => 8
#  notes      :string(255), maximum => 45
#  quote_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

describe QuoteItem do
  
  before(:each) do
    @client = Factory(:client)
    @quote = Factory(:quote, :client => @client, :qtitle => "Incline")
    @attr = { 
      :item_num => "KA3-99",
      :desc => "Rocks",
      :qty => 3,
      :price => 24.99,
      :notes => "Requires some dirt."
      }
  end
  
  it "should create a new instance given valid attributes" do
      @quote.quote_items.create!(@attr)
  end

  describe "quote associations" do

    before(:each) do
      @quote_item = @quote.quote_items.create(@attr)
    end

    it "should have a quote attribute" do
      @quote_item.should respond_to(:quote)
    end

    it "should have the right associated quote" do
      @quote_item.quote_id.should == @quote.id
      @quote_item.quote.should == @quote
    end
  end
  
  describe "validations" do
    
    it "should have a quote id" do
      Quote.new(@attr).should_not be_valid
    end
    
    #Item Number Validation
    it "should require a nonblank item number" do
      @quote.quote_items.build(:item_num => " ").should_not be_valid
    end
    
    it "should reject long item numbers" do
      @quote.quote_items.build(:item_num => "a" * 46).should_not be_valid
    end
    
    #Description Validation
    it "should require a nonblank Description" do
      @quote.quote_items.build(:desc => " ").should_not be_valid
    end
    
    it "should reject long Descriptions" do
      @quote.quote_items.build(:desc => "a" * 46).should_not be_valid
    end
    
    #Quantity Validation
    it "should require a nonblank Quantity" do
      @quote.quote_items.build(:qty => " ").should_not be_valid
    end
    
    it "should reject long Quantities" do
      @quote.quote_items.build(:qty => "a" * 7).should_not be_valid
    end
    
    #Price Validation
    it "should require a nonblank Price" do
      @quote.quote_items.build(:price => " ").should_not be_valid
    end
    
    it "should reject long item Prices" do
      @quote.quote_items.build(:price => "a" * 8).should_not be_valid
    end
    
    #Notes Validation
    it "should require a nonblank Note" do
      @quote.quote_items.build(:notes => " ").should_not be_valid
    end
    
    it "should reject long Notes" do
      @quote.quote_items.build(:notes => "a" * 46).should_not be_valid
    end
    
  end
  
end


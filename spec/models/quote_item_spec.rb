require 'spec_helper'

describe QuoteItem do
  before(:each) do
    @quote = Factory(:quote)
    @attr = { 
              :item_num => "K239-B",
              :desc => "Rocks",
              :qty => 2,
              :price => 24.99,
              :notes => "Requires some dirt."
               }
  end
  
  it "should create a new instance given valid attributes" do
      @quote.quote_items.create!(@attr)
    end

    describe "client associations" do

      before(:each) do
        @quote_item = @quote.quote_items.create(@attr)
      end

      it "should have a quote attribute" do
        @quote_item.should respond_to(:quote)
      end

      it "should have the right associated client" do
        @quote_item.quote_id.should == @quote.id
        @quote_item.quote.should == @quote
      end
    end
end


# == Schema Information
#
# Table name: quote_items
#
#  id         :integer         not null, primary key
#  item_num   :string(255)
#  desc       :string(255)
#  qty        :integer
#  price      :decimal(8, 2)
#  notes      :string(255)
#  quote_id   :integer
#  created_at :datetime
#  updated_at :datetime
#


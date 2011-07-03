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


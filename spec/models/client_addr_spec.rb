require 'spec_helper'

describe ClientAddr do
  before(:each) do
    @client = Factory(:client)
    @attr = { 
        :title => "Primary",
        :street => "Street",
        :city => "City",
        :state => "State",
        :zip => 12345 }
  end

  it "should create a new instance given valid attributes" do
    @client.client_addrs.create!(@attr)
  end
  
  describe "client associations" do

    before(:each) do
      @client_addr = @client.client_addrs.create(@attr)
    end

    it "should have a user attribute" do
      @client_addr.should respond_to(:client)
    end

    it "should have the right associated user" do
      @client_addr.client_id.should == @client.id
      @client_addr.client.should == @client
    end
  end     #end Client Associations
  
  describe "validations" do
    
    it "should have a client id" do
      ClientAddr.new(@attr).should_not be_valid
    end
    
    it "should require nonblank title" do
      @client.client_addrs.build(:title => " ").should_not be_valid
    end
    
    it "should reject long titles" do
      @client.client_addrs.build(:title => "a" * 46).should_not be_valid
    end
    
    it "should require nonblank street" do
      @client.client_addrs.build(:street => " ").should_not be_valid
    end
    
    it "should reject long streets" do
      @client.client_addrs.build(:street => "a" * 141).should_not be_valid
    end
    
    it "should require nonblank city" do
      @client.client_addrs.build(:city => " ").should_not be_valid
    end
    
    it "should reject long cities" do
      @client.client_addrs.build(:city => "a" * 141).should_not be_valid
    end
    
    it "should require nonblank state" do
      @client.client_addrs.build(:state => " ").should_not be_valid
    end
    
    it "should reject long states" do
      @client.client_addrs.build(:state => "a" * 141).should_not be_valid
    end
    
    it "should require nonblank zip" do
      @client.client_addrs.build(:zip => " ").should_not be_valid
    end
    
    it "should reject long streets" do
      @client.client_addrs.build(:zip => "a" * 6).should_not be_valid
    end
    
  end
  
end






# == Schema Information
#
# Table name: client_addrs
#
#  id         :integer         not null, primary key
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :integer
#  client_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#


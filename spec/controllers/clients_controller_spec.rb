require 'spec_helper'

describe ClientsController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @client = Factory(:client)
    end
    
    it "should be successful" do
      get :show, :id => @client
      response.should be_success
    end
    
    it "should find the right client" do
      get :show, :id => @client
      assigns(:client).should == @client
    end
    
    it "should have the right title" do
      get :show, :id => @client
      response.should have_selector('title', :content => @client.first_name + " " + @client.last_name)
    end
    
    it "should have the clients name" do
      get :show, :id => @client
      response.should have_selector('h1', :content => @client.first_name + " " + @client.last_name)
    end
    
    it "should have a profile image" do
      get :show, :id => @client
      response.should have_selector('h1>img', :class => 'gravatar')
    end
    
    it "should have the right URL" do
      get :show, :id => @client
      response.should have_selector('td>a',   :content  => client_path(@client),
                                              :href     => client_path(@client))
    end
    
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign up")
    end
    
  end

end

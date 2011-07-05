require 'spec_helper'

describe QuotesController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'index'" do
      get :index
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'new'" do
      get :new
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'show'" do
      get :show, :id => 1
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'edit'" do
      get :edit, :id => 1
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'update'" do
      put :update, :id => 1, :quote => {}
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
    
  end
  
  describe "GET 'index'" do

    describe "for signed-in clients" do
      before(:each) do
        @client = test_sign_in(Factory(:client))
        Factory(:quote, :client => @client, :qtitle => "Incline")
        Factory(:quote, :client => @client, :qtitle => "Bangalore")
        
        15.times do
          Factory(:quote, :client => @client, :qtitle => Factory.next(:qtitle))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "Client Quotes")
      end
      
      it "should have an element for each quote" do
        get :index
        qtitle_regex = /Incline/i
        Quote.paginate(:page => 1).each do |quote|
          response.should have_selector('span.qtitle') do |qtitle| 
            qtitle.should contain(qtitle_regex)
          end
        end
      end
      
      it "should paginate quotes" do
        get :index
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
      end
      
    end
    
  end       #end GET Index
  
  describe "GET 'show'" do
    
    before(:each) do
      @client = test_sign_in(Factory(:client))
      @quote = Factory(:quote, :client => @client, :qtitle => "San Tropez")
    end
    
    it "should be successful" do
      get :show, :id => @quote
      response.should be_success
    end
    
    it "should find the right quote" do
      get :show, :id => @quote
      assigns(:quote).should == @quote
    end
    
    it "should have the right title" do
      get :show, :id => @quote
      response.should have_selector('title', :content => @quote.qtitle)
    end
    
    it "should have the quotes title" do
      get :show, :id => @quote
      response.should have_selector('h1', :content => @quote.qtitle)
    end
    
    it "should have the clients name" do
      get :show, :id => @quote
      client_name_regex = /#{@client.first_name} #{@client.last_name}/i
      response.should have_selector('h3') do |client_name| 
        client_name.should contain(client_name_regex)
      end
    end
    
    it "should have the right URL" do
      get :show, :id => @quote
      response.should have_selector('a', :href => client_path(@client))
    end
    
    it "should show the quote's quote items" do
      qi1 = Factory(:quote_item, :quote => @quote, :item_num => "KBQ-Z1")
      qi2 = Factory(:quote_item, :quote => @quote, :item_num => "KBQ-Z2")
      get :show, :id => @quote
      response.should have_selector('span.qtitle', :content => qi1.item_num)
      response.should have_selector('span.qtitle', :content => qi2.item_num)
    end
    
=begin
    it "should show the client's addresses" do
      ca1 = Factory(:client_addr, :client => @client, :street => "Street",
                      :city => "City", :state => "State", :zip => 12345)
      ca2 = Factory(:client_addr, :client => @client, :street => "Street 1",
                      :city => "City 1", :state => "State 1", :zip => 12345)
      get :show, :id => @client
      response.should have_selector('span.street', :content => ca1.street)
      response.should have_selector('span.street', :content => ca2.street)
    end
    
    it "should show the client's quotes" do
      quote1 = Factory(:quote, :client => @client, :qtitle => "Incline")
      quote2 = Factory(:quote, :client => @client, :qtitle => "Maine")
      get :show, :id => @client
      response.should have_selector('span.qtitle', :content => quote1.qtitle)
      response.should have_selector('span.qtitle', :content => quote2.qtitle)
    end
    
    it "should paginate quotes" do
      35.times { Factory(:quote, :client => @client, :qtitle => "Incline") }
      get :show, :id => @client
      response.should have_selector('div.pagination')
    end
    
    it "should display the quote count" do
      10.times { Factory(:quote, :client => @client, :qtitle => "Incline") }
      get :show, :id => @client
      response.should have_selector('td.sidebar', :content => @client.quotes.count.to_s)
    end
=end
  end
  
  describe "GET 'new'" do
    
    before(:each) do
      @client = test_sign_in(Factory(:client))
      @quote = @client.quotes.new
    end
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "New Quote")
    end
    
    it "should be for the right client" do
      get :new
      quote = assigns(:quote)
      quote.client.should == @client
    end
    
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @client = test_sign_in(Factory(:client))
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :qtitle => "" }
      end
      
      it "should not create a quote" do
        lambda do
          post :create, :quote => @attr
        end.should_not change(Quote, :count)
      end
      
      it "should re-render the create page" do
        post :create, :quote => @attr
        response.should render_template('new')
      end
      
    end       #end Failure
    
    describe "success" do

      before(:each) do
        @attr = {   :qtitle => "San Tropez" }
      end

      it "should create a quote" do
        lambda do
          post :create, :quote => @attr
        end.should change(Quote, :count).by(1)
      end

      it "should redirect to the client page" do
        post :create, :quote => @attr
        response.should redirect_to(client_path(@client))
      end

      it "should have a flash message" do
        post :create, :quote => @attr
        flash[:success].should =~ /Successfully/i
      end
      
    end       #end Success
    
  end       #end POST Create
  
  describe "GET 'edit'" do
    
    before(:each) do
      @client = test_sign_in(Factory(:client))
      @quote = Factory(:quote, :client => @client, :qtitle => "Miami")
    end
    
    it "should be successful" do
      get :edit, :id => @quote
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @quote
      response.should have_selector('title', :content => "Edit Quote")
    end
    
    #should have a link to edit items
    
  end       #end GET Edit
  
  describe "PUT 'update'" do
    
    before(:each) do
      @client = test_sign_in(Factory(:client))
      @quote = Factory(:quote, :client => @client, 
                    :qtitle => "Miami" )
    end
    
    describe "failure" do
      before(:each) do
        @attr = {   :qtitle => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @quote, :quote => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @quote, :quote => @attr
        response.should have_selector('title', :content => "Edit Quote")
      end
      
    end     #end failure
    
    describe "success" do
      
      before(:each) do
        @attr = {   :qtitle => "Primary" }
      end
      
      it "should change the user's quote attributes" do
        put :update, :id => @quote, :quote => @attr
        quote = assigns(:quote)
        @quote.reload
        @quote.qtitle.should == quote.qtitle
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @quote, :quote => @attr
        response.should redirect_to(client_path(@client))
      end
      
      it "should have a flash message" do
        put :update, :id => @quote, :quote => @attr
        flash[:success].should =~ /Updated!/i
      end
      
    end
      
  end       #end PUT update
  
end

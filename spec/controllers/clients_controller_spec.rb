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
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :first_name => "", 
                  :last_name => "", 
                  :email => "", 
                  :phone => "",
                  :password => "",
                  :password_confirmation => ""}
      end
      
      it "should have the right title" do
        post :create, :client => @attr
        response.should have_selector('title', :content => "Sign Up")
      end
      
      it "should render the 'new' page" do
        post :create, :client => @attr
        response.should render_template('new')
      end
      
      it "should not create client" do
        lambda do
          post :create, :client => @attr
        end.should_not change(Client, :count)
      end
      
    end     #end Failure
    
    describe "success" do
      
      before(:each) do
        @attr = { :first_name => "New", 
                  :last_name => "Client", 
                  :email => "newclient@example.com", 
                  :phone => "0123456789",
                  :password => "foobar",
                  :password_confirmation => "foobar" }
      end
      
      it "should create a client" do
        lambda do
          post :create, :client => @attr
        end.should change(Client, :count).by(1)
      end
      
      it "should redirect to the client show page" do
        post :create, :client => @attr
        response.should redirect_to(client_path(assigns(:client)))
      end
      
      it "should have a welcome message" do
        post :create, :client => @attr
        flash[:success].should =~ /Welcome to the Jungle!/i
      end
      
    end     #end Success
    
  end       #end POST Create
   

end

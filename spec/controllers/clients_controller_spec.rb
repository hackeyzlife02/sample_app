require 'spec_helper'

describe ClientsController do
  render_views

  describe "GET 'index'" do
    
    describe "for non-signed-in clients" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in clients" do
      before(:each) do
        @client = test_sign_in(Factory(:client))
        Factory(:client, :email => "jimmyj@example.com")
        Factory(:client, :email => "jimmyjack@example.com")
        
        30.times do
          Factory(:client, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All Clients")
      end
      
      it "should have an element for each client" do
        get :index
        Client.paginate(:page => 1).each do |client|
          response.should have_selector('li', :content => client.first_name)
        end
      end
      
      it "should paginate clients" do
        get :index
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
      end
      
    end
    
  end

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
      response.should have_selector('td>a',   :href     => client_path(@client))
    end
    
    it "should show the client's addresses" do
      ca1 = Factory(:client_addr, :client => @client, :street => "Street",
                      :city => "City", :state => "State", :zip => 12345)
      ca2 = Factory(:client_addr, :client => @client, :street => "Street 1",
                      :city => "City 1", :state => "State 1", :zip => 12345)
      get :show, :id => @client
      response.should have_selector('span.address', :content => ca1.street)
      response.should have_selector('span.address', :content => ca2.street)
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
      
      it "should sign the client in" do
        post :create, :client => @attr
        controller.should be_signed_in
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
  
  describe "GET 'edit'" do
    
    before(:each) do
      @client = Factory(:client)
      test_sign_in(@client)
    end
    
    it "should be successful" do
      get :edit, :id => @client
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @client
      response.should have_selector('title', :content => "Edit Client")
    end
    
    it "should have a link to change Gravatar" do
      get :edit, :id => @client
      response.should have_selector('a',  :href => 'http://gravatar.com/emails',
                                          :content => "change")
    end
    
    it "should have the right URL" do
      ca1 = Factory(:client_addr, :client => @client, :street => "Street",
                      :city => "City", :state => "State", :zip => 12345)
      get :show, :id => @client
      response.should have_selector('a',   :href     => edit_client_addr_path(ca1))
    end
    
  end       #end GET Edit 
  
  describe "PUT 'update'" do
    
    before(:each) do
      @client = Factory(:client)
      test_sign_in(@client)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :first_name => "", :last_name => "", :email => "", 
                  :password => "", :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @client, :client => @attr
        response.should have_selector('title', :content => "Edit Client")
      end
      
      it "should have the right title" do
        put :update, :id => @client, :client => @attr
        response.should have_selector('title', :content => "Edit Client")
      end
      
    end     #end failure
    
    describe "success" do
      
      before(:each) do
        @attr = { :first_name => "Jimmy", :last_name => "Rogers", :email => "jrogers@example.com", 
                  :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @client, :client => @attr
        client = assigns(:client)
        @client.reload
        @client.first_name.should == client.first_name
        @client.last_name.should == client.last_name
        @client.email.should == client.email
        @client.phone.should == client.phone
        @client.encrypted_password.should == client.encrypted_password
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @client, :client => @attr
        response.should redirect_to(client_path(@client))
      end
      
      it "should have a flash message" do
        put :update, :id => @client, :client => @attr
        flash[:success].should =~ /Profile Updated!/i
      end
      
    end
      
  end       #end PUT update
  
  describe "authentication of edit/update pages" do

    before(:each) do
      @client = Factory(:client)
    end

    describe "for non-signed-in clients" do

      it "should deny access to 'edit'" do
        get :edit, :id => @client
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @client, :client => {}
        response.should redirect_to(signin_path)
      end
    end
  end
end

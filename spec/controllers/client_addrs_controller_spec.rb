require 'spec_helper'

describe ClientAddrsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'edit'" do
      get :edit, :id => 1
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'update'" do
      put :update, :id => 1,  :client_addr => {}
      response.should redirect_to(signin_path)
    end
    
  end
  
  describe "GET 'new'" do
    
    before(:each) do
      @client = Factory(:client)
      test_sign_in(@client)
    end
    
    it "should be successful" do
      get :new, :id => @client
      response.should be_success
    end
    
    it "should have the right title" do
      get :new, :id => @client
      response.should have_selector('title', :content => "Add Address for Client")
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @client = Factory(:client)
      test_sign_in(@client)
    end
    
    describe "failure" do
      before(:each) do
        @attr = {   :title => "",
                    :street => "", 
                    :city => "", 
                    :state => "", 
                    :zip => "" }
      end
      
      it "should not create an address" do
        lambda do
          post :create, :id => @client, :client_addr => @attr
        end.should_not change(ClientAddr, :count)
      end
      
      it "should re-render the create page" do
        post :create, :id => @client, :client_addr => @attr
        response.should render_template('new')
      end
      
    end       #end Failure
    
    describe "success" do

      before(:each) do
        @attr = {   :title => "Primary",
                    :street => "Street", 
                    :city => "City", 
                    :state => "State", 
                    :zip => 12345 }
      end

      it "should create a client address" do
        lambda do
          post :create, :id => @client, :client_addr => @attr
        end.should change(ClientAddr, :count).by(1)
      end

      it "should redirect to the edit page" do
        post :create, :id => @client, :client_addr => @attr
        response.should redirect_to(edit_client_path(@client.id))
      end

      it "should have a flash message" do
        post :create, :id => @client, :client_addr => @attr
        flash[:success].should =~ /Added/i
      end
      
    end       #end Success
    
  end       #end POST Create
  
  describe "GET 'edit'" do
    
    before(:each) do
      @client = Factory(:client)
      test_sign_in(@client)
      @ca1 = Factory(:client_addr, :client => @client,  
                    :title => "Primary",
                    :street => "Street",
                    :city => "City", 
                    :state => "State", 
                    :zip => 12345)
    end
    
    it "should be successful" do
      get :edit, :id => @ca1
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @ca1
      response.should have_selector('title', :content => "Edit Client Address")
    end
    
  end       #end GET Edit

  describe "PUT 'update'" do
    
    before(:each) do
      @client = Factory(:client)
      test_sign_in(@client)
      @ca1 = Factory(:client_addr, :client => @client, 
                    :title => "Primary",
                    :street => "Street",
                    :city => "City", 
                    :state => "State", 
                    :zip => 12345)
    end
    
    describe "failure" do
      before(:each) do
        @attr = {   :title => "",
                    :street => "", 
                    :city => "", 
                    :state => "", 
                    :zip => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @ca1, :client_addr => @attr
        response.should have_selector('title', :content => "Edit Client Address")
      end
      
      it "should have the right title" do
        put :update, :id => @ca1, :client_addr => @attr
        response.should have_selector('title', :content => "Edit Client Address")
      end
      
    end     #end failure
    
    describe "success" do
      
      before(:each) do
        @attr = {   :title => "Primary",
                    :street => "Street", 
                    :city => "City", 
                    :state => "State", 
                    :zip => 12345 }
      end
      
      it "should change the user's address attributes" do
        put :update, :id => @ca1, :client_addr => @attr
        client_addr = assigns(:client_addr)
        @ca1.reload
        @ca1.title.should == client_addr.title
        @ca1.street.should == client_addr.street
        @ca1.city.should == client_addr.city
        @ca1.state.should == client_addr.state
        @ca1.zip.should == client_addr.zip
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @ca1, :client_addr => @attr
        response.should redirect_to(client_path(@client))
      end
      
      it "should have a flash message" do
        put :update, :id => @ca1, :client_addr => @attr
        flash[:success].should =~ /Updated!/i
      end
      
    end
      
  end       #end PUT update

end
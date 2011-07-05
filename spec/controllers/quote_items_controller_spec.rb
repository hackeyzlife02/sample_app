require 'spec_helper'

# @attr = { 
#  :item_num => "KA3-99",
#  :desc => "Rocks",
#  :qty => 3,
#  :price => 24.99,
#  :notes => "Requires some dirt."
#  }
  
describe QuoteItemsController do
  render_views
  
  describe "access control" do
    
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
        @quote1 = Factory(:quote, :client => @client, :qtitle => "Incline")
        @quote1_item = Factory(:quote_item, :quote => @quote1, :item_num => "KBQ-Z1")
        @quote2 = Factory(:quote, :client => @client, :qtitle => "Bangalore")
        @quote2_item = Factory(:quote_item, :quote => @quote2, :item_num => "KBQ-M4" )
        
        15.times do
          qn = Factory(:quote, :client => @client, :qtitle => Factory.next(:qtitle))
          5.times do
            Factory(:quote_item, :quote => qn, :item_num => Factory.next(:item_num))
          end
        end
        
      end
      
    end
    
  end       #end GET Index

  describe "POST 'create'" do

      before(:each) do
        @client = test_sign_in(Factory(:client))
        @quote = Factory(:quote, :client => @client, :qtitle => "Incline")
        @quote_item = Factory(:quote_item, :quote => @quote, :item_num => "KBQ-Z1")
      end

      describe "failure" do

        before(:each) do
          @attr = { 
            :item_num => "",
            :desc => "",
            :qty => "",
            :price => "",
            :notes => ""
            }
        end

        it "should not create a quote item" do
          lambda do
            post :create, :quote_id => @quote.id, :quote_item => @attr
          end.should_not change(QuoteItem, :count)
        end

        it "should render the edit page" do
          post :create, :quote_id => @quote.id, :quote_item => @attr
          response.should redirect_to(edit_quote_path(@quote))
        end
        
        it "should have a error flash message" do
          post :create, :quote_id => @quote.id, :quote_item => @attr
          flash[:error].should =~ /Unable/i
        end
      end

      describe "success" do

        before(:each) do
          @attr = { 
            :item_num => "KA3-99",
            :desc => "Rocks",
            :qty => 3,
            :price => 24.99,
            :notes => "Requires some dirt."
            }
        end

        it "should create a micropost" do
          lambda do
            post :create, :quote_id => @quote.id, :quote_item => @attr
          end.should change(QuoteItem, :count).by(1)
        end

        it "should redirect to the home page" do
          post :create, :quote_id => @quote.id, :quote_item => @attr
          @quote_items = @quote.quote_items
          response.should render_template(@quote_items)
        end

        it "should have a flash message" do
          post :create, :quote_id => @quote.id, :quote_item => @attr
          flash[:success].should =~ /successfully added./i
        end
      end
      
  end

  

end

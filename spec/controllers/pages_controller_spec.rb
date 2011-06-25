require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @base_title = "RoR Sample App"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                          :content => "#{@base_title} | Home")
    end
    
    it "should have a non-blank body" do
      get 'home'
      response.body.should_not =~ /<body>\s*<\/body>/
    end
  end

  describe "GET 'contacts'" do
    it "should be successful" do
      get 'contacts'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contacts'
      response.should have_selector("title",
                          :content => "#{@base_title} | Contacts")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                          :content => "#{@base_title} | About")
    end
  end

end

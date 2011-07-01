require 'spec_helper'

describe "Clients" do
  
  describe "signup" do
    describe "failure" do
      it "should not make a new client" do
        lambda do
          visit signup_path
          fill_in "First name",           :with => ""
          fill_in "Last name",            :with => ""
          fill_in "Email",                :with => ""
          fill_in "Phone",                :with => ""
          fill_in "Password",             :with => ""
          fill_in "Confirm Password",     :with => ""
          click_button
          response.should render_template('clients/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(Client, :count)
      end
    end
    
    describe "success" do
      it "should make a new client" do
        lambda do
          visit signup_path
          fill_in "First name",           :with => "New"
          fill_in "Last name",            :with => "Client"
          fill_in "Email",                :with => "client@example.com"
          fill_in "Phone",                :with => "0123456789"
          fill_in "Password",             :with => "foobar"
          fill_in "Confirm Password",     :with => "foobar"
          click_button
          response.should have_selector('div.flash.success', :content => "Welcome")
          response.should render_template('clients/show')
        end.should change(Client, :count).by(1)
      end
    end
    
    describe "sign in/out" do

      describe "failure" do
        it "should not sign a client in" do
          visit signin_path
          fill_in :email,    :with => ""
          fill_in :password, :with => ""
          click_button
          response.should have_selector("div.flash.error", :content => "Invalid")
        end
      end

      describe "success" do
        it "should sign a client in and out" do
          client = Factory(:client)
          visit signin_path
          fill_in "Email",    :with => client.email
          fill_in "Password", :with => client.password
          click_button
          controller.should be_signed_in
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end
    end
    
  end
  
end

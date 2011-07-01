class ClientsController < ApplicationController
  
  def show
    @client = Client.find(params[:id])
    @title = @client.first_name + " " + @client.last_name
  end
  
  def new
    @title = "Sign up"
    @client = Client.new
  end
  
  def create
    @client = Client.new(params[:client])
    if @client.save
      sign_in @client
      redirect_to @client, :flash => { :success => "Welcome to the Jungle!" }
    else
      @title = "Sign Up"
      render 'new'
    end

  end
end

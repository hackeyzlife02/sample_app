class ClientsController < ApplicationController
  def new
    @title = "Sign up"
    @client = Client.new
  end
  
  def show
    @client = Client.find(params[:id])
    @title = @client.first_name + " " + @client.last_name
  end
end

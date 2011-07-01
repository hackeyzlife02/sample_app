class ClientsController < ApplicationController
  def new
    @title = "Sign up"
  end
  
  def show
    @client = Client.find(params[:id])
    @title = @client.first_name + " " + @client.last_name
  end
end

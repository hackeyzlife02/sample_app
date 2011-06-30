class ClientsController < ApplicationController
  def new
    @title = "Sign up"
  end
  
  def show
    @client = Client.find(params[:id])
  end
end

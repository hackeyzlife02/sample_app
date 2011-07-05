class ClientsController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_client, :only => [:edit, :update]
  
  def index
    @title = "All Clients"
    @clients = Client.paginate(:all, :page => params[:page], :per_page => 10)
  end
  
  def show
    @client = Client.find(params[:id])
    @client_addrs = @client.client_addrs
    @client_addr = @client.client_addrs.first
    @quotes = @client.quotes.paginate(:page => params[:page], :per_page => 5)
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
  
  def destroy
    @client.find(params[:id]).destroy
    redirect_to clients_path, :flash => { :success => "Client Deleted." }
  end
  
  def edit
    @client = Client.find(params[:id])
    @client_addrs = @client.client_addrs.all
    @client_addr = @client.client_addrs.find_by_id(1)
    @title = "Edit Client"
  end
  
  def update
    @client = Client.find(params[:id])
    @client_addrs = @client.client_addrs
    if @client.update_attributes(params[:client])
      redirect_to @client, :flash => { :success => "Profile Updated!" }
    else
      @title = "Edit Client"
      render 'edit'
    end
  end
  
  private
  
    def correct_client
      @client = Client.find(params[:id])
      redirect_to(root_path) unless current_client?(@client)
    end
end
